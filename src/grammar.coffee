{Parser} = require 'jison'

unwrap = /^function\s*\(\)\s*\{\s*return\s*([\s\S]*);\s*\}/

o = (patternString, action, options) ->
  patternString = patternString.replace /\s{2,}/g, ' '
  patternCount = patternString.split(' ').length
  if action
    action = if match = unwrap.exec action then match[1] else "(#{action}())"

    action = action.replace /\bnew /g, '$&yy.'
    action = action.replace /\b(?:Block\.wrap|extend)\b/g, 'yy.$&'

    getAddDataToNodeFunctionString = (first, last) ->
      "yy.addDataToNode(yy, @#{first}#{if last then ", @#{last}" else ''})"

    action = action.replace /LOC\(([0-9]*)\)/g, getAddDataToNodeFunctionString('$1')
    action = action.replace /LOC\(([0-9]*),\s*([0-9]*)\)/g, getAddDataToNodeFunctionString('$1', '$2')
    performActionFunctionString = "$$ = #{getAddDataToNodeFunctionString(1, patternCount)}(#{action});"
  else
    performActionFunctionString = '$$ = $1;'

  [patternString, performActionFunctionString, options]

grammar =
  Root: [
    o '', -> new Block
    o 'Body'
  ]

operators = [
  ['left',      '.', '?.', '::', '?::']
  ['left',      'CALL_START', 'CALL_END']
  ['nonassoc',  '++', '--']
  ['right',     'UNARY']
  ['right',     'AWAIT']
  ['right',     '**']
  ['right',     'UNARY_MATH']
  ['left',      'MATH']
  ['left',      '+', '-']
  ['left',      'SHIFT']
  ['left',      'RELATION']
  ['left',      'COMPARE']
  ['left',      '^']
  ['left',      '|']
  ['left',      '&&']
  ['left',      '||']
  ['left',      'BIN?']
  ['nonassoc',  'INDENT', 'OUTDENT']
  ['right',     'YIELD']
  ['right',     '=', ':', 'COMPOUND_ASSIGN', 'RETURN', 'THROW', 'EXTENDS']
  ['right',     'FORIN', 'FOROF', 'FORFORM', 'BY', 'WHEN']
  ['right',     'IF', 'ELSE', 'FOR', 'WHILE', 'UNTIL', 'LOOP', 'SUPER', 'CLASS', 'IMPORT', 'EXPORT']
  ['left',      'POST_IF']
]

tokens = []
for name, alternatives of grammar
  grammar[name] = for alt in alternatives
    for token in alt[0].split ' '
      tokens.push token unless grammar[token]
    alt[1] = "return #{alt[1]}" if name is 'Root'
    alt

exports.parser = new Parser
  tokens      : tokens.join ' '
  bnf         : grammar
  operators   : operators.reverse()
  startSymbol : 'Root'
