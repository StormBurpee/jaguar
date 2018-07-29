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
