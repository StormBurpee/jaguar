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

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 139)
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
    25,    14,    23,    24,    91,    14,    16,    17,    18,    19,
    20,    21,    22,    25,    72,    23,    24,    74,    14,    16,
    17,    18,    19,    20,    21,    22,    72,    44,    45,    50,
    48,    14,    15,    28,    13,    71,    15,    47,    39,    40,
    87,    46,    78,    43,    77,    76,    28,    13,    25,    15,
    23,    24,    28,    80,    16,    17,    18,    19,    20,    21,
    22,    25,    15,    23,    24,    82,    41,    16,    17,    18,
    19,    20,    21,    22,    86,    26,    85,    25,    72,    23,
    24,    72,    13,    16,    17,    18,    19,    20,    21,    22,
    25,    52,    23,    24,   nil,    13,    16,    17,    18,    19,
    20,    21,    22,    78,   nil,    89,    25,   nil,    23,    24,
   nil,    13,    16,    17,    18,    19,    20,    21,    22,    25,
   nil,    23,    24,   nil,    13,    16,    17,    18,    19,    20,
    21,    22,   nil,   nil,   nil,    25,   nil,    23,    24,   nil,
    13,    16,    17,    18,    19,    20,    21,    22,    25,   nil,
    23,    24,   nil,    13,    16,    17,    18,    19,    20,    21,
    22,   nil,   nil,   nil,    25,   nil,    23,    24,   nil,    13,
    16,    17,    18,    19,    20,    21,    22,    25,   nil,    23,
    24,   nil,    13,    16,    17,    18,    19,    20,    21,    22,
   nil,   nil,   nil,    25,   nil,    23,    24,   nil,    13,    16,
    17,    18,    19,    20,    21,    22,    25,   nil,    23,    24,
   nil,    13,    16,    17,    18,    19,    20,    21,    22,   nil,
   nil,   nil,    25,   nil,    23,    24,   nil,    13,    16,    17,
    18,    19,    20,    21,    22,    25,   nil,    23,    24,   nil,
    13,    16,    17,    18,    19,    20,    21,    22,   nil,   nil,
   nil,    25,   nil,    23,    24,   nil,    13,    16,    17,    18,
    19,    20,    21,    22,    25,   nil,    23,    24,   nil,    13,
    16,    17,    18,    19,    20,    21,    22,   nil,   nil,   nil,
    25,   nil,    23,    24,   nil,    13,    16,    17,    18,    19,
    20,    21,    22,    25,   nil,    23,    24,   nil,    13,    16,
    17,    18,    19,    20,    21,    22,   nil,   nil,   nil,    25,
   nil,    23,    24,   nil,    13,    16,    17,    18,    19,    20,
    21,    22,    25,   nil,    23,    24,   nil,    13,    16,    17,
    18,    19,    20,    21,    22,    28,   nil,   nil,   nil,    28,
    39,    40,   nil,    13,    39,    40,    37,    38,    33,    34,
    35,    36,    31,    32,    30,    29,    13,   nil,    72,    66,
    28,   nil,   nil,   nil,   nil,    39,    40,    37,    38,    33,
    34,    35,    36,    31,    32,    30,    29,    28,   nil,   nil,
   nil,   nil,    39,    40,    37,    38,    33,    34,    35,    36,
    31,    32,    30,    29,    28,   nil,   nil,   nil,   nil,    39,
    40,    37,    38,    33,    34,    35,    36,    31,    32,    30,
    29,    28,   nil,   nil,   nil,   nil,    39,    40,    37,    38,
    33,    34,    35,    36,    31,    32,    30,    29,    28,   nil,
   nil,   nil,   nil,    39,    40,    37,    38,    33,    34,    35,
    36,    31,    32,    30,    29,    28,   nil,   nil,   nil,   nil,
    39,    40,    37,    38,    33,    34,    35,    36,    31,    32,
    30,    29,    28,   nil,   nil,   nil,   nil,    39,    40,    37,
    38,    33,    34,    35,    36,    31,    32,    30,    29,    28,
   nil,   nil,   nil,   nil,    39,    40,    37,    38,    33,    34,
    35,    36,    31,    32,    30,    28,   nil,   nil,   nil,   nil,
    39,    40,    37,    38,    33,    34,    35,    36,    31,    32,
    28,   nil,   nil,   nil,   nil,    39,    40,    37,    38,    33,
    34,    35,    36,    28,   nil,   nil,   nil,   nil,    39,    40,
    37,    38,    33,    34,    35,    36,    28,   nil,   nil,   nil,
    28,    39,    40,    37,    38,    39,    40,    37,    38,    28,
   nil,   nil,   nil,    28,    39,    40,    37,    38,    39,    40,
    37,    38 ]

racc_action_check = [
    72,     2,    72,    72,    86,    72,    72,    72,    72,    72,
    72,    72,    72,     0,    47,     0,     0,    48,     0,     0,
     0,     0,     0,     0,     0,     0,    48,    21,    21,    26,
    24,    81,     2,    61,    72,    47,    72,    23,    61,    61,
    81,    21,    67,    21,    67,    52,    63,     0,    76,     0,
    76,    76,    64,    71,    76,    76,    76,    76,    76,    76,
    76,    13,    81,    13,    13,    74,     8,    13,    13,    13,
    13,    13,    13,    13,    79,     1,    79,    41,    82,    41,
    41,    85,    76,    41,    41,    41,    41,    41,    41,    41,
    78,    28,    78,    78,   nil,    13,    78,    78,    78,    78,
    78,    78,    78,    83,   nil,    83,    37,   nil,    37,    37,
   nil,    41,    37,    37,    37,    37,    37,    37,    37,    38,
   nil,    38,    38,   nil,    78,    38,    38,    38,    38,    38,
    38,    38,   nil,   nil,   nil,    39,   nil,    39,    39,   nil,
    37,    39,    39,    39,    39,    39,    39,    39,    40,   nil,
    40,    40,   nil,    38,    40,    40,    40,    40,    40,    40,
    40,   nil,   nil,   nil,    25,   nil,    25,    25,   nil,    39,
    25,    25,    25,    25,    25,    25,    25,    46,   nil,    46,
    46,   nil,    40,    46,    46,    46,    46,    46,    46,    46,
   nil,   nil,   nil,    27,   nil,    27,    27,   nil,    25,    27,
    27,    27,    27,    27,    27,    27,    43,   nil,    43,    43,
   nil,    46,    43,    43,    43,    43,    43,    43,    43,   nil,
   nil,   nil,    29,   nil,    29,    29,   nil,    27,    29,    29,
    29,    29,    29,    29,    29,    30,   nil,    30,    30,   nil,
    43,    30,    30,    30,    30,    30,    30,    30,   nil,   nil,
   nil,    31,   nil,    31,    31,   nil,    29,    31,    31,    31,
    31,    31,    31,    31,    32,   nil,    32,    32,   nil,    30,
    32,    32,    32,    32,    32,    32,    32,   nil,   nil,   nil,
    33,   nil,    33,    33,   nil,    31,    33,    33,    33,    33,
    33,    33,    33,    34,   nil,    34,    34,   nil,    32,    34,
    34,    34,    34,    34,    34,    34,   nil,   nil,   nil,    35,
   nil,    35,    35,   nil,    33,    35,    35,    35,    35,    35,
    35,    35,    36,   nil,    36,    36,   nil,    34,    36,    36,
    36,    36,    36,    36,    36,    62,   nil,   nil,   nil,    42,
    62,    62,   nil,    35,    42,    42,    42,    42,    42,    42,
    42,    42,    42,    42,    42,    42,    36,   nil,    49,    42,
    49,   nil,   nil,   nil,   nil,    49,    49,    49,    49,    49,
    49,    49,    49,    49,    49,    49,    49,    69,   nil,   nil,
   nil,   nil,    69,    69,    69,    69,    69,    69,    69,    69,
    69,    69,    69,    69,    65,   nil,   nil,   nil,   nil,    65,
    65,    65,    65,    65,    65,    65,    65,    65,    65,    65,
    65,    68,   nil,   nil,   nil,   nil,    68,    68,    68,    68,
    68,    68,    68,    68,    68,    68,    68,    68,    84,   nil,
   nil,   nil,   nil,    84,    84,    84,    84,    84,    84,    84,
    84,    84,    84,    84,    84,    51,   nil,   nil,   nil,   nil,
    51,    51,    51,    51,    51,    51,    51,    51,    51,    51,
    51,    51,     3,   nil,   nil,   nil,   nil,     3,     3,     3,
     3,     3,     3,     3,     3,     3,     3,     3,     3,    53,
   nil,   nil,   nil,   nil,    53,    53,    53,    53,    53,    53,
    53,    53,    53,    53,    53,    54,   nil,   nil,   nil,   nil,
    54,    54,    54,    54,    54,    54,    54,    54,    54,    54,
    56,   nil,   nil,   nil,   nil,    56,    56,    56,    56,    56,
    56,    56,    56,    55,   nil,   nil,   nil,   nil,    55,    55,
    55,    55,    55,    55,    55,    55,    58,   nil,   nil,   nil,
    59,    58,    58,    58,    58,    59,    59,    59,    59,    60,
   nil,   nil,   nil,    57,    60,    60,    60,    60,    57,    57,
    57,    57 ]

racc_action_pointer = [
    11,    75,    -6,   445,   nil,   nil,   nil,   nil,    32,   nil,
   nil,   nil,   nil,    59,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     7,   nil,    24,    16,   162,    29,   191,    78,   220,
   233,   249,   262,   278,   291,   307,   320,   104,   117,   133,
   146,    75,   322,   204,   nil,   nil,   175,    -1,    11,   343,
   nil,   428,     9,   462,   478,   506,   493,   536,   519,   523,
   532,    16,   318,    29,    35,   377,   nil,     7,   394,   360,
   nil,    40,    -2,   nil,    51,   nil,    46,   nil,    88,    39,
   nil,    24,    63,    68,   411,    66,    -9,   nil,   nil,   nil,
   nil,   nil ]

racc_action_default = [
    -1,   -56,    -2,    -3,    -6,    -7,    -8,    -9,   -10,   -11,
   -12,   -13,   -14,   -56,   -16,   -17,   -18,   -19,   -20,   -21,
   -22,   -23,   -44,   -56,   -56,   -56,   -56,    -5,   -56,   -56,
   -56,   -56,   -56,   -56,   -56,   -56,   -56,   -56,   -56,   -56,
   -56,   -56,   -56,   -27,   -38,   -39,   -56,   -56,   -56,   -56,
    92,    -4,   -25,   -30,   -31,   -32,   -33,   -34,   -35,   -36,
   -37,   -40,   -41,   -42,   -43,   -46,   -15,   -56,   -28,   -45,
   -47,   -49,   -56,   -52,   -56,   -54,   -27,   -24,   -56,   -56,
   -50,   -56,   -56,   -56,   -29,   -56,   -56,   -55,   -53,   -26,
   -48,   -51 ]

racc_goto_table = [
    27,     2,    42,    70,    73,    75,    67,     1,    79,   nil,
   nil,   nil,   nil,   nil,    49,   nil,    51,   nil,    53,    54,
    55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
    65,   nil,    68,   nil,   nil,    69,   nil,   nil,    88,    83,
   nil,    90,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    68,   nil,    84,   nil,   nil,
   nil,   nil,   nil,    81,   nil,   nil,   nil,   nil,   nil,    27 ]

racc_goto_check = [
     4,     2,     3,    14,    14,    14,    13,     1,    15,   nil,
   nil,   nil,   nil,   nil,     3,   nil,     3,   nil,     3,     3,
     3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
     3,   nil,     3,   nil,   nil,     3,   nil,   nil,    14,    13,
   nil,    14,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,     3,   nil,     3,   nil,   nil,
   nil,   nil,   nil,     2,   nil,   nil,   nil,   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,     7,     1,   -11,    -2,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   -37,   -44,   -63 ]

racc_goto_default = [
   nil,   nil,   nil,     3,     4,     5,     6,     7,     8,     9,
    10,    11,    12,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 40, :_reduce_1,
  1, 40, :_reduce_2,
  1, 41, :_reduce_3,
  3, 41, :_reduce_4,
  2, 41, :_reduce_5,
  1, 41, :_reduce_6,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  1, 42, :_reduce_none,
  3, 42, :_reduce_15,
  1, 43, :_reduce_none,
  1, 43, :_reduce_none,
  1, 44, :_reduce_18,
  1, 44, :_reduce_19,
  1, 44, :_reduce_20,
  1, 44, :_reduce_21,
  1, 44, :_reduce_22,
  1, 45, :_reduce_23,
  4, 45, :_reduce_24,
  3, 45, :_reduce_25,
  6, 45, :_reduce_26,
  0, 52, :_reduce_27,
  1, 52, :_reduce_28,
  3, 52, :_reduce_29,
  3, 46, :_reduce_30,
  3, 46, :_reduce_31,
  3, 46, :_reduce_32,
  3, 46, :_reduce_33,
  3, 46, :_reduce_34,
  3, 46, :_reduce_35,
  3, 46, :_reduce_36,
  3, 46, :_reduce_37,
  2, 46, :_reduce_38,
  2, 46, :_reduce_39,
  3, 46, :_reduce_40,
  3, 46, :_reduce_41,
  3, 46, :_reduce_42,
  3, 46, :_reduce_43,
  1, 47, :_reduce_44,
  3, 48, :_reduce_45,
  3, 48, :_reduce_46,
  3, 49, :_reduce_47,
  6, 49, :_reduce_48,
  0, 54, :_reduce_49,
  1, 54, :_reduce_50,
  3, 54, :_reduce_51,
  3, 50, :_reduce_52,
  5, 50, :_reduce_53,
  3, 51, :_reduce_54,
  3, 53, :_reduce_55 ]

racc_reduce_n = 56

racc_shift_n = 92

racc_token_table = {
  false => 0,
  :error => 1,
  :IF => 2,
  :ELSE => 3,
  :DEF => 4,
  :CLASS => 5,
  :EXTENDS => 6,
  :NEWLINE => 7,
  :NUMBER => 8,
  :STRING => 9,
  :TRUE => 10,
  :FALSE => 11,
  :NULL => 12,
  :IDENTIFIER => 13,
  :CONSTANT => 14,
  :INDENT => 15,
  :DEDENT => 16,
  "." => 17,
  "EXTENDS" => 18,
  "!" => 19,
  "++" => 20,
  "--" => 21,
  "*" => 22,
  "/" => 23,
  "+" => 24,
  "-" => 25,
  ">" => 26,
  ">=" => 27,
  "<" => 28,
  "<=" => 29,
  "==" => 30,
  "!=" => 31,
  "&&" => 32,
  "||" => 33,
  "=" => 34,
  "," => 35,
  "(" => 36,
  ")" => 37,
  ";" => 38 }

racc_nt_base = 39

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
  "EXTENDS",
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
  "\"EXTENDS\"",
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

module_eval(<<'.,.,', 'grammar.y', 117)
  def _reduce_53(val, _values, result)
     result = ClassNode.new(val[1], val[4], val[3]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 121)
  def _reduce_54(val, _values, result)
     result = IfNode.new(val[1], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 125)
  def _reduce_55(val, _values, result)
     result = val[1] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser

end
