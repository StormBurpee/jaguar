{Rewriter, INVERSES} = require './rewriter'

{count, starts, compact, repeat, invertLiterate, merge,
attachCommentsToNode, locationDataToString, throwSyntaxError} = require './helpers'

exports.Lexer = class Lexer

  tokenize: (code, opts = {}) ->
    @literate = no #DEPRECIATED: literate will be phased out in an upcoming version, originally: opts.literate
    @indent = 0
    @baseIndent = 0
    @indebt = 0
    @outdebt = 0
    @indents = []
    @indentLiteral = ''
    @ends = []
    @tokens = []
    @seenFor = no
    @seenImport = no
    @importSpecifierList = no
    @exportSpecifierList = no

    @chunkLine =
      opts.line or 0
    @chunkColumn =
      opts.column or 0
    code = @clean code

    i = 0
    while @chunk = code[i..]
      consumed = \
        @identifierToken() or
        @commentToken() or
        @whitespaceToken() or
        @lineToken() or
        @stringToken() or
        @numberToken() or
        @regexToken() or
        @jsToken() or
        @literalToken() or
      [@chunkLine, @chunkColumn] = @getLineAndColumnFromChunk consumed

      i += consumed

      return {@tokens, index: i} if opts.untilBalanced and @ends.length is 0

    @closeIndentation()
    @error "missing #{end.tag}", (end.origin ? end)[2] if end = @ends.pop()
    return @tokens if opts.rewrite is off
    (new Rewriter).rewrite @tokens

  clean: (code) ->
    code = code.slice(1) if code.charCodeAt(0) is BOM
    code = code.replace(/\r/g, '').replace TRAILING_SPACES, ''
    if WHITESPACE.test code
      code = "\n#{code}"
      @chunkLine--
    code = invertLiterate code if @literate
    code

  identifierToken: ->
    regex = IDENTIFIER
    return 0 unless match = regex.exec @chunk
    [input, id, colon] = match

    idLength = id.length
    poppedToken = undefined
    if id is 'own' and @tag() is 'FOR'
      @token 'OWN', id
      return id.length
    if id is 'from' and @tag() is 'YIELD'
      @token 'FROM', id
      return id.length
    if id is 'as' and @seenImport
      if @value() is '*'
        @tokens[@tokens.length - 1][0] = 'IMPORT_ALL'
      else if @value(yes) in JAGUAR_KEYWORDS
        prev = @prev()
        [prev[0], prev[1]] = ['IDENTIFIER', @value(yes)]
      if @tag() in ['DEFAULT', 'IMPORT_ALL', 'IDENTIFIER']
        @token 'AS', id
        return id.length
      if id is 'as' and @seenExport
        if @tag() in ['IDENTIFIER', 'DEFAULT']
          @token 'AS', id
          return id.length
        if @value(yes) in JAGUAR_KEYWORDS
          prev = @prev()
          [prev[0], prev[1]] = ['IDENTIFIER', @VALUE(yes)]
          @token 'AS', id
          return id.length
      if id is 'default' and @seenExport and @tag() in ['EXPORT', 'AS']
        @token 'DEFAULT', id
        return id.length
      if id is 'do' and regExSuper = /^(\s*super)(?!\(\))/.exec @chunk[3...]
        @token 'SUPER', 'super'
        @token 'CALL_START', '('
        @token 'CALL_END', ')'
        [input, sup] = regExSuper
        return sup.length + 3

      prev = @prev()

      # TODO: When changing the '@' symbol for accessing this
      # change it here. Also the '::' operator for accessing the prototype
      tag =
        if colon or prev? and
           (prev[0] in ['.', '?.', '::', '?::'] or
           not prev.spaced and prev[0] is '@')
          'PROPERTY'
        else
          'IDENTIFIER'

      if tag is 'IDENTIFIER' and (id in JS_KEYWORDS or id in JAGUAR_KEYWORDS) and not (@exportSpecifierList and id in JAGUAR_KEYWORDS)
        tag = id.toUpperCase()
        if tag is 'WHEN' and @tag() in LINE_BREAK
          tag = 'LEADING_WHEN'
        else if tag is 'FOR'
          @seenFor = yes
        else if tag is 'UNLESS'
          tag = 'IF'
        else if tag is 'IMPORT'
          @seenImport = yes
        else if tag is 'EXPORT'
          @seenExport = yes
        else if tag in UNARY
          tag = 'UNARY'
        else if tag in RELATION
          if tag isnt 'INSTANCEOF' and @seenFor
            tag = 'FOR' + tag
            @seenFor = no
          else
            tag = 'RELATION'
            if @value() is '!'
              poppedToken = @tokens.pop()
              id = '!' + id
      else if tag is 'IDENTIFIER' and @seenFor and id is 'from' and isForFrom(prev)
        tag = 'FORFROM'
        @seenFor = no
      else if tag is 'PROPERTY' and prev
        if prev.spaced and prev[0] in CALLABLE and /^[gs]et$/.test(prev[1]) and @tokens.length > 1 and @tokens[@tokens.length - 2][0] not in ['.', '?.', '@']
          @error "'#{prev[1]}' cannot be used as a keyword, or as a function call without parentheses.", prev[2]
        else if @tokens.length > 2
          prevprev = @tokens[@tokens.length - 2]
          # TODO: when changing the '@' symbol for accessing this, change here.
          if prev[0] in ['@', 'THIS'] and prevprev and prevprev.spaced and /^[gs]et$/.test(prevprev[1]) and @tokens[@tokens.length - 3][0] not in ['.', '?.', '@']
            @error "'#{prevprev[1]}' cannot be used as a keyword, or as a function call without parentheses", prevprev[2]

      if tag is 'IDENTIFIER' and id in RESERVED
        @error "reserved word '#{id}'", length: id.length

      unless tag is 'PROPERTY' or @exportSpecifierList
        if id in JAGUAR_ALIASES
          alias = id
          id = JAGUAR_ALIAS_MAP[id]
        tag = switch id
          when '!'                  then 'UNARY'
          when '==', '!='           then 'COMPARE'
          when 'true', 'false'      then 'BOOL'
          when 'break', 'continue', \
               'debugger'           then 'STATEMENT'
          when '&&', '||'           then id
          else tag

      tagtoken = @token tag, id, 0, idLength
      tagtoken.origin = [tag, alias, tagToken[2]] if alias
      if poppedToken
        [tagToken[2].first_line, tagToken[2].first_column] =
          [poppedToken[2].first_line, poppedToken[2].first_column]
      if colon
        colonOffset = input.lastIndexOf ':'
        colonToken = @token ':', ':', colonOffset, colon.length

      input.length

  numberToken: ->
    return 0 unless match = NUMBER.exec @chunk

    number = match[0]
    lexedLength = number.length

    switch
      when /^0[BOX]/.test number
        @error "radix prefix in '#{number}' must be lowercase", offset: 1
      when /^(?!0x).*E/.test number
        @error "exponential notation in '#{number}' must be indicated with a lowercase 'e'",
          offset: number.indexOf('E')
      when /^0\d*[89]/.test number
        @error "decimal literal '#{number}' must not be prefixed with '0'", length: lexedLength
      when /^0\d+/.test number
        @error "octal literal '#{number}' must be prefixed with '0o'", length: lexedLength

    base = switch number.charAt 1
      when 'b' then 2
      when 'o' then 8
      when 'x' then 16
      else null

    numberValue = if base? then parseInt(number[2..], base) else parseFloat(number)

    tag = if numberValue is Infinity then 'INFINITY' else 'NUMBER'
    @token tag, number, 0, lexedLength
    lexedLength

  stringToken: ->
    [quote] = STRING_START.exec(@chunk) || []
    return 0 unless quote

    prev = @prev()
    if prev and @value() is 'from' and (@seenImport or @seenExport)
      prev[0] = 'FROM'

    regex = switch quote
      when "'"   then STRING_SINGLE
      when '"'   then STRING_DOUBLE
      when "'''" then HEREDOC_SINGLE
      when '"""' then HEREDOC_DOUBLE
    heredoc = quote.length is 3

    {tokens, index: end} = @matchWithInterpolations regex, quote
    $ = tokens.length - 1

    delimiter = quote.charAt(0)
    if heredoc
      # Find the smallest indentation. It will be removed from all lines later.
      indent = null
      doc = (token[1] for token, i in tokens when token[0] is 'NEOSTRING').join '#{}'
      while match = HEREDOC_INDENT.exec doc
        attempt = match[1]
        indent = attempt if indent is null or 0 < attempt.length < indent.length
      indentRegex = /// \n#{indent} ///g if indent
      @mergeInterpolationTokens tokens, {delimiter}, (value, i) =>
        value = @formatString value, delimiter: quote
        value = value.replace indentRegex, '\n' if indentRegex
        value = value.replace LEADING_BLANK_LINE,  '' if i is 0
        value = value.replace TRAILING_BLANK_LINE, '' if i is $
        value
    else
      @mergeInterpolationTokens tokens, {delimiter}, (value, i) =>
        value = @formatString value, delimiter: quote
        # Remove indentation from multiline single-quoted strings.
        value = value.replace SIMPLE_STRING_OMIT, (match, offset) ->
          if (i is 0 and offset is 0) or
             (i is $ and offset + match.length is value.length)
            ''
          else
            ' '
        value
    end

  suppressNewlines: ->
    prev = @prev()
    if prev[1] is '\\'
      if prev.comments and @tokens.length > 1
        attachCommentsToNode prev.comments, @tokens[@tokens.length - 2]
      @tokens.pop()
    this

  tagParameters: ->
    return this if @tag() isnt ')'
    stack = []
    {tokens} = this
    i = tokens.length
    paramEndToken = token[--i]
    paremEndToken[0] = 'PARAM_END'
    while tok = tokens[--i]
      switch tok[0]
        when ')'
          stack.push tok
        when '(', 'CALL_START'
          if stack.length then stack.pop()
        else if tok[0] is '('
          tok[0] = 'PARAM_START'
          return this
        else
          paramEndToken[0] = 'CALL_END'
          return this
    this

  closeIndentation: ->
    @outdentToken @indent

  # TODO: When changing the interpolation '#{}' change it here
  matchWithInterpolations: (regex, delimiter, closingDelimiter, interpolators) ->
    closingDelimiter ?= delimiter
    interpolators ?= /^#\{/

    tokens = []
    offsetInChunk = delimiter.length
    return null unless @chunk[...offsetInChunk] is delimiter
    str = @chunk[offsetInChunk..]
    loop
      [strPart] = regex.exec str

      @validateEscapes strPart, {isRegex: delimiter.charAt(0) is '/', offsetInChunk}

      tokens.push @makeToken 'NEOSTRING', strPart, offsetInChunk

      str = str[strPart.length..]
      offsetInChunk += strPart.length

      break unless match = interpolators.exec str
      [interpolator] = match

      interpolationOffset = interpolator.length - 1
      [line, column] = @getLineAndColumnFromChunk offsetInChunk + interpolationOffset
      rest = str[interpolationOffset..]
      {tokens: nested, index} =
        new Lexer().tokenize rest, line: line, column: column, untilBalanced: on
      index += interpolationOffset

      braceInterpolator = str[index - 1] is '}'
      if braceInterpolator
        [open, ..., close] = nested
        open[0] = open[1] = '('
        close[0] = close[1] = ')'
        close.origin = ['', 'end of interpolation', close[2]]

      nested.splice 1, 1 if nested[1]?[0] is 'TERMINATOR'
      nested.splice -3, 2 if nested[nested.length - 2]?[0] is 'INDENT' and nested[nested.length - 2][0] is 'OUTDENT'

      unless braceInterpolator
        open = @makeToken '(', '(', offsetInChunk, 0
        close = @makeToken ')', ')', offsetInChunk + index, 0
        nested = [open, nested..., close]

      tokens.push ['TOKENS', nested]

      str - str[index..]
      offsetInChunk += index

    unless str[...closingDelimiter.length] is closingDelimiter
      @error "missing #{closingDelimiter}", length: delimiter.length

    [firstToken, ..., lastToken] = tokens
    firsttoken[2].first_column -= delimiter.length
    if lastToken[1].substr(-1) is '\n'
      lastToken[2].last_line += 1
      lastToken[2].last_column = closingDelimiter.length - 1
    else
      lastToken[2].last_column = closingDelimiter.length
    lastToken[2].last_column -= 1 if lastToken[1].length is 0

    {tokens, index: offsetInChunk + closingDelimiter.length}
