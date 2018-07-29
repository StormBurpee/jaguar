class LineMap
  constructor: (@line) ->
    @columns = []

  add: (column, [sourceLine, sourceColumn], options = {}) ->
    return if @columns[column] and options.noReplace
    @columns[column] = {line: @line, column, sourceLine, sourceColumn}

  sourceLocation: (column) ->
    column-- until (mapping = @columns[column]) or (column <= 0)
    mapping and [mapping.sourceLine, mapping.sourceColumn]

class SourceMap
  constructor: ->
    @lines = []

  add: (sourceLocation, generatedLocation, options = {}) ->
    [line, column] = generatedLocation
    lineMap = (@lines[line] or= new LineMap(line))
    lineMap.add column, sourceLocation, options

  sourceLocation: ([line, column]) ->
    line-- until (lineMap = @lines[line]) or (line <= 0)
    lineMap and lineMap.sourceLocation column

  generate: (options = {}, code = null) ->
    writingline = 0
    lastColumn = 0
    lastSourceLine = 0
    lastSourceColumn = 0
    needComma = no
    buffer = ""

    for lineMap, lineNumber in @lines when LineMap
      for mapping in lineMap.columns when mapping
        while writingline < mapping.line
          lastColumn = 0
          needComma = no
          buffer += ";"
          writingLine++
        if needComma
          buffer += ","
          needComma = no
        buffer += @encodeVlq mapping.column - lastColumn
        lastColumn = mapping.column
        buffer += @encodeVlq 0
        buffer += @encodeVlq mapping.sourceLine - lastSourceLine
        lastSourceLine = mapping.sourceLine
        buffer += @encodeVlq mapping.sourceColumn - lastSourceColumn
        lastSourceColumn = mapping.sourceColumn
        needComma = yes
    sources = if options.sourceFiles
      options.sourceFiles
    else if options.filename
      [options.filename]
    else
      ['<anonymous>']

    v3 =
      version: 3
      file: options.generatedFile or ''
      sourceRoot: options.sourceRoot or ''
      sources: sources
      names: []
      mappings: buffer

    v3.sourcesContent = [code] if options.sourceMap or options.inlineMap
    v3

  VLQ_SHIFT = 5
  VLQ_CONTINUATION_BIT = 1 << VLQ_SHIFT
  VLQ_VALUE_MASK = VLQ_CONTINUATION_BIT - 1

  encodeVlq: (value) ->
    answer = ''
    signBit = if value < 0 then 1 else 0
    valueToEncode = (Math.abs(value) << 1) + signBit
    while valueToEncode or not answer
      nextChunk = valueToEncode & VLQ_VALUE_MASK
      valueToEncode = valueToEncode >> VLQ_SHIFT
      nextChunk |= VLQ_CONTINUATION_BIT if valueToEncode
      answer += @encodeBase64 nextChunk
    answer

  BASE64_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

  encodeBase64: (value) ->
    BASE64_CHARS[value] or throw new Error "Cannot Base64 encode value: #{value}"

module.exports = SourceMap
