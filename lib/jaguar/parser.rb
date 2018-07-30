#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.14
# from Racc grammer file "".
#

require 'racc/parser.rb'

require_relative "lexer"
require_relative "nodes"
require_relative "parse_error"

module Jaguar

class Parser < Racc::Parser

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 138)
  def parse(code, show_tokens=false)
    @tokens = Lexer.new.tokenize(code)
    puts @tokens.inspect if show_tokens
    do_parse
  end

  def next_token
    @tokens.shift
  end

  def on_error(error_token_id, error_value, value_stack)
    raise ParseError.new(token_to_str(error_token_id), error_value, value_stack)
  end

...end grammar.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
    25,    14,    23,    24,    14,    16,    17,    18,    19,    20,
    21,    22,    25,    72,    23,    24,    14,    16,    17,    18,
    19,    20,    21,    22,    28,    88,    37,    38,    14,    72,
    52,    15,    13,    71,    15,    50,    28,    85,    37,    38,
    41,    42,    39,    40,    13,    25,    15,    23,    24,    79,
    16,    17,    18,    19,    20,    21,    22,    25,    15,    23,
    24,    48,    16,    17,    18,    19,    20,    21,    22,    28,
    47,    37,    38,    25,    43,    23,    24,    13,    16,    17,
    18,    19,    20,    21,    22,    25,    26,    23,    24,    13,
    16,    17,    18,    19,    20,    21,    22,    46,    77,    45,
    76,    25,    72,    23,    24,    13,    16,    17,    18,    19,
    20,    21,    22,    25,    75,    23,    24,    13,    16,    17,
    18,    19,    20,    21,    22,    77,    84,    86,    83,    25,
   nil,    23,    24,    13,    16,    17,    18,    19,    20,    21,
    22,    25,   nil,    23,    24,    13,    16,    17,    18,    19,
    20,    21,    22,   nil,   nil,   nil,   nil,    25,   nil,    23,
    24,    13,    16,    17,    18,    19,    20,    21,    22,    25,
   nil,    23,    24,    13,    16,    17,    18,    19,    20,    21,
    22,   nil,   nil,   nil,   nil,    25,   nil,    23,    24,    13,
    16,    17,    18,    19,    20,    21,    22,    25,   nil,    23,
    24,    13,    16,    17,    18,    19,    20,    21,    22,   nil,
   nil,   nil,   nil,    25,   nil,    23,    24,    13,    16,    17,
    18,    19,    20,    21,    22,    25,   nil,    23,    24,    13,
    16,    17,    18,    19,    20,    21,    22,   nil,   nil,   nil,
   nil,    25,   nil,    23,    24,    13,    16,    17,    18,    19,
    20,    21,    22,    25,   nil,    23,    24,    13,    16,    17,
    18,    19,    20,    21,    22,   nil,   nil,   nil,   nil,    25,
   nil,    23,    24,    13,    16,    17,    18,    19,    20,    21,
    22,    25,   nil,    23,    24,    13,    16,    17,    18,    19,
    20,    21,    22,   nil,   nil,   nil,   nil,    25,   nil,    23,
    24,    13,    16,    17,    18,    19,    20,    21,    22,    25,
   nil,    23,    24,    13,    16,    17,    18,    19,    20,    21,
    22,    28,   nil,    37,    38,    41,    42,   nil,    28,    13,
    37,    38,    41,    42,    39,    40,    33,    34,    35,    36,
    28,    13,    37,    38,    41,    42,    39,    40,    33,    34,
    35,    36,    31,    32,    30,    29,    72,   nil,    28,    66,
    37,    38,    41,    42,    39,    40,    33,    34,    35,    36,
    31,    32,    30,    29,    28,   nil,    37,    38,    41,    42,
    39,    40,    33,    34,    35,    36,    31,    32,    30,    29,
    28,   nil,    37,    38,    41,    42,    39,    40,    33,    34,
    35,    36,    31,    32,    30,    29,    28,   nil,    37,    38,
    41,    42,    39,    40,    33,    34,    35,    36,    31,    32,
    30,    29,    28,   nil,    37,    38,    41,    42,    39,    40,
    33,    34,    35,    36,    31,    32,    30,    29,    28,   nil,
    37,    38,    41,    42,    39,    40,    33,    34,    35,    36,
    31,    32,    30,    29,    28,   nil,    37,    38,    41,    42,
    39,    40,    33,    34,    35,    36,    31,    32,    30,    29,
    28,   nil,    37,    38,    41,    42,    39,    40,    33,    34,
    35,    36,    31,    32,    30,    28,   nil,    37,    38,    41,
    42,    39,    40,    33,    34,    35,    36,    31,    32,    28,
   nil,    37,    38,    41,    42,    39,    40,    33,    34,    35,
    36,    28,   nil,    37,    38,    41,    42,    39,    40,    28,
   nil,    37,    38,    41,    42,    39,    40,    28,   nil,    37,
    38,    41,    42,    39,    40,    28,   nil,    37,    38,    41,
    42 ]

racc_action_check = [
     0,     2,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,    72,    47,    72,    72,    72,    72,    72,    72,
    72,    72,    72,    72,    64,    84,    64,    64,    80,    48,
    28,     2,     0,    47,     0,    26,    59,    80,    59,    59,
    59,    59,    59,    59,    72,    77,    72,    77,    77,    71,
    77,    77,    77,    77,    77,    77,    77,    32,    80,    32,
    32,    24,    32,    32,    32,    32,    32,    32,    32,    63,
    23,    63,    63,    13,     8,    13,    13,    77,    13,    13,
    13,    13,    13,    13,    13,    33,     1,    33,    33,    32,
    33,    33,    33,    33,    33,    33,    33,    21,    67,    21,
    67,    34,    83,    34,    34,    13,    34,    34,    34,    34,
    34,    34,    34,    35,    52,    35,    35,    33,    35,    35,
    35,    35,    35,    35,    35,    81,    78,    81,    78,    36,
   nil,    36,    36,    34,    36,    36,    36,    36,    36,    36,
    36,    39,   nil,    39,    39,    35,    39,    39,    39,    39,
    39,    39,    39,   nil,   nil,   nil,   nil,    40,   nil,    40,
    40,    36,    40,    40,    40,    40,    40,    40,    40,    41,
   nil,    41,    41,    39,    41,    41,    41,    41,    41,    41,
    41,   nil,   nil,   nil,   nil,    42,   nil,    42,    42,    40,
    42,    42,    42,    42,    42,    42,    42,    43,   nil,    43,
    43,    41,    43,    43,    43,    43,    43,    43,    43,   nil,
   nil,   nil,   nil,    45,   nil,    45,    45,    42,    45,    45,
    45,    45,    45,    45,    45,    46,   nil,    46,    46,    43,
    46,    46,    46,    46,    46,    46,    46,   nil,   nil,   nil,
   nil,    75,   nil,    75,    75,    45,    75,    75,    75,    75,
    75,    75,    75,    25,   nil,    25,    25,    46,    25,    25,
    25,    25,    25,    25,    25,   nil,   nil,   nil,   nil,    27,
   nil,    27,    27,    75,    27,    27,    27,    27,    27,    27,
    27,    29,   nil,    29,    29,    25,    29,    29,    29,    29,
    29,    29,    29,   nil,   nil,   nil,   nil,    30,   nil,    30,
    30,    27,    30,    30,    30,    30,    30,    30,    30,    31,
   nil,    31,    31,    29,    31,    31,    31,    31,    31,    31,
    31,    62,   nil,    62,    62,    62,    62,   nil,    56,    30,
    56,    56,    56,    56,    56,    56,    56,    56,    56,    56,
    44,    31,    44,    44,    44,    44,    44,    44,    44,    44,
    44,    44,    44,    44,    44,    44,    49,   nil,    49,    44,
    49,    49,    49,    49,    49,    49,    49,    49,    49,    49,
    49,    49,    49,    49,    65,   nil,    65,    65,    65,    65,
    65,    65,    65,    65,    65,    65,    65,    65,    65,    65,
    69,   nil,    69,    69,    69,    69,    69,    69,    69,    69,
    69,    69,    69,    69,    69,    69,     3,   nil,     3,     3,
     3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
     3,     3,    82,   nil,    82,    82,    82,    82,    82,    82,
    82,    82,    82,    82,    82,    82,    82,    82,    51,   nil,
    51,    51,    51,    51,    51,    51,    51,    51,    51,    51,
    51,    51,    51,    51,    68,   nil,    68,    68,    68,    68,
    68,    68,    68,    68,    68,    68,    68,    68,    68,    68,
    53,   nil,    53,    53,    53,    53,    53,    53,    53,    53,
    53,    53,    53,    53,    53,    54,   nil,    54,    54,    54,
    54,    54,    54,    54,    54,    54,    54,    54,    54,    55,
   nil,    55,    55,    55,    55,    55,    55,    55,    55,    55,
    55,    60,   nil,    60,    60,    60,    60,    60,    60,    57,
   nil,    57,    57,    57,    57,    57,    57,    58,   nil,    58,
    58,    58,    58,    58,    58,    61,   nil,    61,    61,    61,
    61 ]

racc_action_pointer = [
    -2,    86,    -5,   390,   nil,   nil,   nil,   nil,    42,   nil,
   nil,   nil,   nil,    71,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    65,   nil,    58,    48,   251,    35,   267,    18,   279,
   295,   307,    55,    83,    99,   111,   127,   nil,   nil,   139,
   155,   167,   183,   195,   324,   211,   223,    -1,    15,   342,
   nil,   422,    80,   454,   469,   483,   312,   503,   511,    20,
   495,   519,   305,    53,     8,   358,   nil,    65,   438,   374,
   nil,    37,    10,   nil,   nil,   239,   nil,    43,    93,   nil,
    22,    92,   406,    88,    13,   nil,   nil,   nil,   nil ]

racc_action_default = [
    -1,   -55,    -2,    -3,    -6,    -7,    -8,    -9,   -10,   -11,
   -12,   -13,   -14,   -55,   -16,   -17,   -18,   -19,   -20,   -21,
   -22,   -23,   -44,   -55,   -55,   -55,   -55,    -5,   -55,   -55,
   -55,   -55,   -55,   -55,   -55,   -55,   -55,   -38,   -39,   -55,
   -55,   -55,   -55,   -55,   -55,   -27,   -55,   -55,   -55,   -55,
    89,    -4,   -25,   -30,   -31,   -32,   -33,   -34,   -35,   -36,
   -37,   -40,   -41,   -42,   -43,   -46,   -15,   -55,   -28,   -45,
   -47,   -49,   -55,   -52,   -53,   -27,   -24,   -55,   -55,   -50,
   -55,   -55,   -29,   -55,   -55,   -54,   -26,   -48,   -51 ]

racc_goto_table = [
    27,     2,    44,    70,    73,    74,    67,     1,    78,   nil,
   nil,   nil,   nil,   nil,    49,   nil,    51,   nil,    53,    54,
    55,    56,    57,    58,    59,    60,   nil,   nil,    61,    62,
    63,    64,    65,   nil,    68,    69,    81,   nil,   nil,    87,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    68,   nil,    82,   nil,   nil,   nil,
   nil,   nil,   nil,    80,   nil,   nil,   nil,   nil,    27 ]

racc_goto_check = [
     4,     2,     3,    14,    14,    14,    13,     1,    15,   nil,
   nil,   nil,   nil,   nil,     3,   nil,     3,   nil,     3,     3,
     3,     3,     3,     3,     3,     3,   nil,   nil,     3,     3,
     3,     3,     3,   nil,     3,     3,    13,   nil,   nil,    14,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,     3,   nil,     3,   nil,   nil,   nil,
   nil,   nil,   nil,     2,   nil,   nil,   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,     7,     1,   -11,    -2,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   -39,   -44,   -63 ]

racc_goto_default = [
   nil,   nil,   nil,     3,     4,     5,     6,     7,     8,     9,
    10,    11,    12,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 38, :_reduce_1,
  1, 38, :_reduce_2,
  1, 39, :_reduce_3,
  3, 39, :_reduce_4,
  2, 39, :_reduce_5,
  1, 39, :_reduce_6,
  1, 40, :_reduce_none,
  1, 40, :_reduce_none,
  1, 40, :_reduce_none,
  1, 40, :_reduce_none,
  1, 40, :_reduce_none,
  1, 40, :_reduce_none,
  1, 40, :_reduce_none,
  1, 40, :_reduce_none,
  3, 40, :_reduce_15,
  1, 41, :_reduce_none,
  1, 41, :_reduce_none,
  1, 42, :_reduce_18,
  1, 42, :_reduce_19,
  1, 42, :_reduce_20,
  1, 42, :_reduce_21,
  1, 42, :_reduce_22,
  1, 43, :_reduce_23,
  4, 43, :_reduce_24,
  3, 43, :_reduce_25,
  6, 43, :_reduce_26,
  0, 50, :_reduce_27,
  1, 50, :_reduce_28,
  3, 50, :_reduce_29,
  3, 44, :_reduce_30,
  3, 44, :_reduce_31,
  3, 44, :_reduce_32,
  3, 44, :_reduce_33,
  3, 44, :_reduce_34,
  3, 44, :_reduce_35,
  3, 44, :_reduce_36,
  3, 44, :_reduce_37,
  2, 44, :_reduce_38,
  2, 44, :_reduce_39,
  3, 44, :_reduce_40,
  3, 44, :_reduce_41,
  3, 44, :_reduce_42,
  3, 44, :_reduce_43,
  1, 45, :_reduce_44,
  3, 46, :_reduce_45,
  3, 46, :_reduce_46,
  3, 47, :_reduce_47,
  6, 47, :_reduce_48,
  0, 52, :_reduce_49,
  1, 52, :_reduce_50,
  3, 52, :_reduce_51,
  3, 48, :_reduce_52,
  3, 49, :_reduce_53,
  3, 51, :_reduce_54 ]

racc_reduce_n = 55

racc_shift_n = 89

racc_token_table = {
  false => 0,
  :error => 1,
  :IF => 2,
  :ELSE => 3,
  :DEF => 4,
  :CLASS => 5,
  :NEWLINE => 6,
  :NUMBER => 7,
  :STRING => 8,
  :TRUE => 9,
  :FALSE => 10,
  :NULL => 11,
  :IDENTIFIER => 12,
  :CONSTANT => 13,
  :INDENT => 14,
  :DEDENT => 15,
  "." => 16,
  "!" => 17,
  "++" => 18,
  "--" => 19,
  "*" => 20,
  "/" => 21,
  "+" => 22,
  "-" => 23,
  ">" => 24,
  ">=" => 25,
  "<" => 26,
  "<=" => 27,
  "==" => 28,
  "!=" => 29,
  "&&" => 30,
  "||" => 31,
  "=" => 32,
  "," => 33,
  "(" => 34,
  ")" => 35,
  ";" => 36 }

racc_nt_base = 37

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "IF",
  "ELSE",
  "DEF",
  "CLASS",
  "NEWLINE",
  "NUMBER",
  "STRING",
  "TRUE",
  "FALSE",
  "NULL",
  "IDENTIFIER",
  "CONSTANT",
  "INDENT",
  "DEDENT",
  "\".\"",
  "\"!\"",
  "\"++\"",
  "\"--\"",
  "\"*\"",
  "\"/\"",
  "\"+\"",
  "\"-\"",
  "\">\"",
  "\">=\"",
  "\"<\"",
  "\"<=\"",
  "\"==\"",
  "\"!=\"",
  "\"&&\"",
  "\"||\"",
  "\"=\"",
  "\",\"",
  "\"(\"",
  "\")\"",
  "\";\"",
  "$start",
  "Root",
  "Expressions",
  "Expression",
  "Terminator",
  "Literal",
  "Call",
  "Operator",
  "Constant",
  "Assign",
  "Def",
  "Class",
  "If",
  "ArgList",
  "Block",
  "ParamList" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'grammar.y', 27)
  def _reduce_1(val, _values, result)
     result = Nodes.new([]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 28)
  def _reduce_2(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 32)
  def _reduce_3(val, _values, result)
     result = Nodes.new(val) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 33)
  def _reduce_4(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 34)
  def _reduce_5(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 35)
  def _reduce_6(val, _values, result)
     result = Nodes.new([]) 
    result
  end
.,.,

# reduce 7 omitted

# reduce 8 omitted

# reduce 9 omitted

# reduce 10 omitted

# reduce 11 omitted

# reduce 12 omitted

# reduce 13 omitted

# reduce 14 omitted

module_eval(<<'.,.,', 'grammar.y', 47)
  def _reduce_15(val, _values, result)
     result = val[1] 
    result
  end
.,.,

# reduce 16 omitted

# reduce 17 omitted

module_eval(<<'.,.,', 'grammar.y', 56)
  def _reduce_18(val, _values, result)
     result = NumberNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 57)
  def _reduce_19(val, _values, result)
     result = StringNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 58)
  def _reduce_20(val, _values, result)
     result = TrueNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 59)
  def _reduce_21(val, _values, result)
     result = FalseNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 60)
  def _reduce_22(val, _values, result)
     result = NullNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 64)
  def _reduce_23(val, _values, result)
     result = CallNode.new(nil, val[0], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 65)
  def _reduce_24(val, _values, result)
     result = CallNode.new(nil, val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 66)
  def _reduce_25(val, _values, result)
     result = CallNode.new(val[0], val[2], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 68)
  def _reduce_26(val, _values, result)
     result = CallNode.new(val[0], val[2], val[4]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 72)
  def _reduce_27(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 73)
  def _reduce_28(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 74)
  def _reduce_29(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 78)
  def _reduce_30(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 79)
  def _reduce_31(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 80)
  def _reduce_32(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 81)
  def _reduce_33(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 82)
  def _reduce_34(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 83)
  def _reduce_35(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 84)
  def _reduce_36(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 85)
  def _reduce_37(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 86)
  def _reduce_38(val, _values, result)
     result = CallNode.new(val[0], val[1], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 87)
  def _reduce_39(val, _values, result)
     result = CallNode.new(val[0], val[1], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 88)
  def _reduce_40(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 89)
  def _reduce_41(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 90)
  def _reduce_42(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 91)
  def _reduce_43(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 95)
  def _reduce_44(val, _values, result)
     result = GetConstantNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 99)
  def _reduce_45(val, _values, result)
     result = SetLocalNode.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 100)
  def _reduce_46(val, _values, result)
     result = SetConstantNode.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 104)
  def _reduce_47(val, _values, result)
     result = DefNode.new(val[1], [], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 106)
  def _reduce_48(val, _values, result)
     result = DefNode.new(val[1], val[3], val[5]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 110)
  def _reduce_49(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 111)
  def _reduce_50(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 112)
  def _reduce_51(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 116)
  def _reduce_52(val, _values, result)
     result = ClassNode.new(val[1], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 120)
  def _reduce_53(val, _values, result)
     result = IfNode.new(val[1], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 124)
  def _reduce_54(val, _values, result)
     result = val[1] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser

end
