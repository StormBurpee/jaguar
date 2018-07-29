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
  
