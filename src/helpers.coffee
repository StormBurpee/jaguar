exports.starts = (string, literal, start) ->
  literal is string.substr start, literal.length

exports.ends = (string, literal, back) ->
  len = literal.length
  literal is string.substr string.length - len - (back or 0), len
