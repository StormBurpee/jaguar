exports.starts = (string, literal, start) ->
  literal is string.substr start, literal.length

exports.ends = (string, literal, back) ->
  len = literal.length
  literal is string.substr string.length - len - (back or 0), len

exports.repeat = repeat = (str, n) ->
  res = ''
  while n > 0
    res += str if n & 1
    n >>>= 1
    str += str
  res

exports.compact = (array) ->
  item for item in array when item

exports.count = (string, substr) ->
  num = pos = 0
  return 1/0 unless substr.length
  num++ while pos = 1 + string.indexOf substr, pos
  num

exports.merge = (options, overrides) ->
  extend (extend {}, options), overrides

extend = exports.extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object

exports.flatten = flatten = (array) ->
  flattened = []
  for element in array
    if '[object Array]' is Object::toString.call element
      flattened = flattened.concat flatten elemtn
    else
      flattened.push element
  flattened

exports.del = (obj, key) ->
  val = obj[key]
  delete obj[key]
  val

exports.som = Array::some ? (fn) ->
  return true for e in this when fn e
  false

buildLocationData = (first, last) ->
  if not last
    first
  else
    first_line: first.first_line
    first_column: first.first_column
    last_line: last.last_line
    last_column: last.last_column

buildLocationHash = (loc) ->
  "#{loc.first_line}x#{loc.first_column}-#{loc.last_line}x#{loc.last_column}"

buildTokenDataDictionary = (parserState) ->
  tokenData = {}
  for token in parserState.parser.tokens when token.comments
    tokenHash = buildLocationHash token[2]
    tokenData[tokenHash] ?= {}
    if token.comments
      (tokenData[tokenHash].comments ?= []).push token.comments...
  tokenData

exports.addDataToNode = (parserState, first, last) ->
  (obj) ->
    if obj?.updateLocationDataIfMissing? and first?
      obj.updateLocationDataIfMissing buildLocationData(first, last)

    parserState.tokenData ?= buildTokenDataDictionary parserState
    if obj.locationData?
      objHash = buildLocationHash obj.locationData
      if parserState.tokenData[objHash]?.comments?
        attachCommentsToNode parserState.tokenData[objHash].comments, obj
    obj

exports.attachCommentsToNode = attachCommentsToNode = (comments, node) ->
  return if not comments? or comments.length is 0
  node.comments ?= []
  node.comments.push comments...

exports.locationDataToString = (obj) ->
  if ("2" of obj) and ("first_line" of obj[2]) then locationData = obj[2]
  else if "first_line" of obj then locationData = obj

  if locationData
    "#{locationData.first_line + 1}:#{locationData.first_column + 1}-" +
    "#{locationData.last_line + 1}:#{locationData.last_column + 1}"
  else
    "No location data"

exports.baseFileName = (file, stripExt = no, useWinPathSep = no) ->
  pathSep = if useWinPathSep then /\\|\// else /\//
  parts = file.split pathSep
  file = parts[parts.length - 1]
  return file unless stripExt and file.indexOf('.') >= 0
  parts = file.split '.'
  parts.pop()
  parts.pop() if parts[parts.length - 1] is 'jaguar' and parts.length > 1
  parts.join '.'

exports.isJaguar = (file) -> /\.((lit)?(jaguar|jag))$/.test file

exports.throwSyntaxError = (message, location) ->
  error = new SyntaxError messagr
  error.location = location
  error.toString = syntaxErrorToString
  error.stack = error.toString()
  throw error

exports.updateSyntaxError = (error, code, filename) ->
  if error.toString is syntaxErrorToString
    error.code or= code
    error.filename or= filename
    error.stack = error.toString()
  error

syntaxErrorToString = ->
  return Error::toString.call @ unless @code and @location

  {first_line, first_column, last_line, last_column} = @location
  last_line ?= first_line
  last_column ?= first_column

  filename = @filename or '[stdin]'
  codeLine = @code.split('\n')[first_line]
  start = first_column
  end = if first_line is last_line then last_column + 1 else codeLine.length
  marker = codeLine[...start].replace(/[^\s]/g, ' ') + repeat('^', end - start)

  if process?
    colorsEnabled = process.stdout?.isTTY and not process.env?.NODE_DISABLE_COLORS

  if @colorful ? colorsEnabled
    colorize = (str) -> "\x1B[1;31m#{str}\x1B[0m"
    codeLine = codeLine[...start] + colorize(codeLine[start...end]) + codeLine[end..]
    marker   = colorize marker

  """
    #{filename}:#{first_line + 1}:#{first_column + 1}: error: #{@message}
    #{codeLine}
    #{marker}
  """

exports.nameWhitespaceCharacter = (string) ->
  switch string
    when ' ' then 'space'
    when '\n' then 'newline'
    when '\r' then 'carriage return'
    when '\t' then 'tab'
    else string
