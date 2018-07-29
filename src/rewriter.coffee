{throwSyntaxError} = require './helpers'

moveComments = (fromToken, toToken) ->
  return unless fromToken.comments
  if toToken.comments and toToken.comments.length isnt 0
    unshiftedComments = []
    for comment in fromToken.comments
      if comment.unshift
        unshiftedComments.push comment
      else
        toToken.comments.push comment
    toToken.comments = unshiftedComments.concat toToken.comments
  else
    toToken.comments = fromToken.comments
  delete fromToken.comments

generate = (tag, value, origin, commentsToken) ->
  token = [tag, value]
  token.generated = yes
  token.origin = origin if origin
  moveComments commentsToken, token if commentsToken
  token

exports.Rewriter = class Rewriter

  rewrite: (@tokens) ->

# list of token pairs that must be balanced.
BALANCED_PAIRS = [
  ['(', ')']
  ['[', ']']
  ['{', '}']
  ['INDENT', 'OUTDENT'],
  ['CALL_START', 'CALL_END']
  ['PARAM_START', 'PARAM_END']
  ['INDEX_START', 'INDEX_END']
  ['STRING_START', 'STRING_END']
  ['REGEX_START', 'REGEX_END']
]

exports.INVERSES = INVERSES = {}

EXPRESSION_START  = []
EXPRESSION_END    = []

for [left, right] in BALANCED_PAIRS
  EXPRESSION_START.push INVERSES[right] = left
  EXPRESSION_END  .push INVERSES[left] = right

EXPRESSION_CLOSE  = ['CATCH', 'THEN', 'ELSE', 'FINALLY'].concat EXPRESSION_END

IMPLICIT_FUNC     = ['IDENTIFIER', 'PROPERTY', 'SUPER', ')', 'CALL_END', ']', 'INDEX_END', '@', 'THIS']

IMPLICIT_CALL     = [
  'IDENTIFIER', 'PROPERTY', 'NUMBER', 'INFINITY', 'NAN'
  'STRING', 'STRING_START', 'REGEX', 'REGEX_START', 'JS'
  'NEW', 'PARAM_START', 'CLASS', 'IF', 'TRY', 'SWITCH', 'THIS'
  'UNDEFINED', 'NULL', 'BOOL',
  'UNARY', 'YIELD', 'AWAIT', 'UNARY_MATH', 'SUPER', 'THROW'
  '@', '->', '=>', '[', '(', '{', '--', '++'
]

IMPLICIT_UNSPACED_CALL = ['+', '-']

IMPLICIT_END      = ['POST_IF', 'FOR', 'WHILE', 'UNTIL', 'WHEN', 'BY', 'LOOP', 'TERMINATOR']

SINGLE_LINERS     = ['ELSE', '->', '=>', 'TRY', 'FINALLY', 'THEN']
SINGLE_CLOSERS    = ['TERMINATOR', 'CATCH', 'FINALLY', 'ELSE', 'OUTDENT', 'LEADING_WHEN']

LINEBREAKS        = ['TERMINATOR', 'INDENT', 'OUTDENT']

CALL_CLOSERS      = ['.', '?.', '::', '?::']

CONTROL_IN_IMPLICIT = ['IF', 'TRY', 'FINALLY', 'CATCH', 'CLASS', 'SWITCH']

DISCARDED = ['(', ')', '[', ']', '{', '}', '.', '..', '...', ',', '=', '++', '--', '?',
  'AS', 'AWAIT', 'CALL_START', 'CALL_END', 'DEFAULT', 'ELSE', 'EXTENDS', 'EXPORT',
  'FORIN', 'FOROF', 'FORFROM', 'IMPORT', 'INDENT', 'INDEX_SOAK', 'LEADING_WHEN',
  'OUTDENT', 'PARAM_END', 'REGEX_START', 'REGEX_END', 'RETURN', 'STRING_END', 'THROW',
  'UNARY', 'YIELD'
].concat IMPLICIT_UNSPACED_CALL.concat IMPLICIT_END.concat CALL_CLOSERS.concat CONTROL_IN_IMPLICIT
