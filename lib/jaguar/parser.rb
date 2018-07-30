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

module_eval(<<'...end grammar.y/module_eval...', 'grammar.y', 146)
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
    24,    91,    23,    96,    14,    16,    17,    18,    19,    20,
    21,    22,    24,    81,    23,    52,    14,    16,    17,    18,
    19,    20,    21,    22,    24,    55,    23,    84,    14,    16,
    17,    18,    19,    20,    21,    22,    52,    24,    13,    23,
    15,    79,    16,    17,    18,    19,    20,    21,    22,    24,
    13,    23,    15,    52,    16,    17,    18,    19,    20,    21,
    22,    24,    13,    23,    15,    86,    16,    17,    18,    19,
    20,    21,    22,    81,    24,    13,    23,    53,    91,    16,
    17,    18,    19,    20,    21,    22,    24,    13,    23,    46,
    93,    16,    17,    18,    19,    20,    21,    22,    24,    13,
    23,    25,    97,    16,    17,    18,    19,    20,    21,    22,
    52,    24,    13,    23,    57,   nil,    16,    17,    18,    19,
    20,    21,    22,    24,    13,    23,   nil,   nil,    16,    17,
    18,    19,    20,    21,    22,    24,    13,    23,   nil,   nil,
    16,    17,    18,    19,    20,    21,    22,   nil,    24,    13,
    23,   nil,   nil,    16,    17,    18,    19,    20,    21,    22,
    24,    13,    23,   nil,   nil,    16,    17,    18,    19,    20,
    21,    22,    24,    13,    23,   nil,   nil,    16,    17,    18,
    19,    20,    21,    22,   nil,    24,    13,    23,   nil,   nil,
    16,    17,    18,    19,    20,    21,    22,    24,    13,    23,
   nil,   nil,    16,    17,    18,    19,    20,    21,    22,    24,
    13,    23,   nil,   nil,    16,    17,    18,    19,    20,    21,
    22,   nil,    24,    13,    23,   nil,   nil,    16,    17,    18,
    19,    20,    21,    22,    24,    13,    23,   nil,   nil,    16,
    17,    18,    19,    20,    21,    22,    24,    13,    23,   nil,
   nil,    16,    17,    18,    19,    20,    21,    22,   nil,    24,
    13,    23,   nil,   nil,    16,    17,    18,    19,    20,    21,
    22,    24,    13,    23,   nil,   nil,    16,    17,    18,    19,
    20,    21,    22,    24,    13,    23,    14,   nil,    16,    17,
    18,    19,    20,    21,    22,    92,    24,    13,    23,   nil,
    52,    16,    17,    18,    19,    20,    21,    22,    24,    13,
    23,   nil,   nil,    16,    17,    18,    19,    20,    21,    22,
   nil,    13,    15,    49,    51,    27,    48,   nil,    40,    41,
    36,    37,    27,   nil,    13,    40,    41,    36,    37,    44,
    45,    42,    43,    88,    27,    99,    13,    40,    41,    36,
    37,    44,    45,    42,    43,    32,    33,    34,    35,    30,
    31,    38,    39,    29,    28,    52,    88,    27,    87,    75,
    40,    41,    36,    37,    44,    45,    42,    43,    32,    33,
    34,    35,    30,    31,    38,    39,    29,    28,    27,   nil,
   nil,    40,    41,    36,    37,    44,    45,    42,    43,    32,
    33,    34,    35,    30,    31,    38,    39,    29,    28,    27,
   nil,   nil,    40,    41,    36,    37,    44,    45,    42,    43,
    32,    33,    34,    35,    30,    31,    38,    39,    29,    28,
    27,   nil,   nil,    40,    41,    36,    37,    44,    45,    42,
    43,    32,    33,    34,    35,    30,    31,    38,    39,    29,
    28,    27,   nil,   nil,    40,    41,    36,    37,    44,    45,
    42,    43,    32,    33,    34,    35,    30,    31,    38,    39,
    29,    28,    27,   nil,   nil,    40,    41,    36,    37,    44,
    45,    42,    43,    32,    33,    34,    35,    30,    31,    38,
    39,    29,    28,    27,   nil,   nil,    40,    41,    36,    37,
    44,    45,    42,    43,    32,    33,    34,    35,    30,    31,
    38,    39,    29,    28,    27,   nil,   nil,    40,    41,    36,
    37,    44,    45,    42,    43,    32,    33,    34,    35,    30,
    31,    38,    39,    29,    27,   nil,   nil,    40,    41,    36,
    37,    44,    45,    42,    43,    32,    33,    34,    35,    30,
    31,    38,    39,    27,   nil,   nil,    40,    41,    36,    37,
    44,    45,    42,    43,    32,    33,    34,    35,    30,    31,
    38,    39,    27,   nil,   nil,    40,    41,    36,    37,    44,
    45,    42,    43,    32,    33,    34,    35,    30,    31,    38,
    39,    27,   nil,   nil,    40,    41,    36,    37,    44,    45,
    42,    43,    32,    33,    34,    35,    27,   nil,   nil,    40,
    41,    36,    37,    44,    45,    42,    43,    32,    33,    34,
    35,    27,   nil,   nil,    40,    41,    36,    37,    44,    45,
    42,    43,    27,   nil,   nil,    40,    41,    36,    37,    44,
    45,    42,    43,    27,   nil,   nil,    40,    41,    36,    37,
    44,    45,    42,    43,    27,   nil,   nil,    40,    41,    36,
    37,    44,    45,    27,   nil,   nil,    40,    41,    36,    37,
    44,    45,    27,   nil,   nil,   -61,   -61,   -61,   -61,    27,
   nil,   nil,    40,    41,    36,    37,    27,   nil,   nil,   -61,
   -61,   -61,   -61 ]

racc_action_check = [
     0,    89,     0,    89,     0,     0,     0,     0,     0,     0,
     0,     0,    52,    51,    52,    96,    52,    52,    52,    52,
    52,    52,    52,    52,    86,    25,    86,    53,     2,    86,
    86,    86,    86,    86,    86,    86,    53,    13,     0,    13,
     0,    51,    13,    13,    13,    13,    13,    13,    13,    49,
    52,    49,    52,    80,    49,    49,    49,    49,    49,    49,
    49,    88,    86,    88,     2,    57,    88,    88,    88,    88,
    88,    88,    88,    79,    42,    13,    42,    23,    80,    42,
    42,    42,    42,    42,    42,    42,    43,    49,    43,     8,
    84,    43,    43,    43,    43,    43,    43,    43,    44,    88,
    44,     1,    91,    44,    44,    44,    44,    44,    44,    44,
    93,    45,    42,    45,    27,   nil,    45,    45,    45,    45,
    45,    45,    45,    46,    43,    46,   nil,   nil,    46,    46,
    46,    46,    46,    46,    46,    48,    44,    48,   nil,   nil,
    48,    48,    48,    48,    48,    48,    48,   nil,    24,    45,
    24,   nil,   nil,    24,    24,    24,    24,    24,    24,    24,
    26,    46,    26,   nil,   nil,    26,    26,    26,    26,    26,
    26,    26,    28,    48,    28,   nil,   nil,    28,    28,    28,
    28,    28,    28,    28,   nil,    29,    24,    29,   nil,   nil,
    29,    29,    29,    29,    29,    29,    29,    30,    26,    30,
   nil,   nil,    30,    30,    30,    30,    30,    30,    30,    31,
    28,    31,   nil,   nil,    31,    31,    31,    31,    31,    31,
    31,   nil,    32,    29,    32,   nil,   nil,    32,    32,    32,
    32,    32,    32,    32,    33,    30,    33,   nil,   nil,    33,
    33,    33,    33,    33,    33,    33,    34,    31,    34,   nil,
   nil,    34,    34,    34,    34,    34,    34,    34,   nil,    35,
    32,    35,   nil,   nil,    35,    35,    35,    35,    35,    35,
    35,    36,    33,    36,   nil,   nil,    36,    36,    36,    36,
    36,    36,    36,    37,    34,    37,    82,   nil,    37,    37,
    37,    37,    37,    37,    37,    82,    38,    35,    38,   nil,
    21,    38,    38,    38,    38,    38,    38,    38,    39,    36,
    39,   nil,   nil,    39,    39,    39,    39,    39,    39,    39,
   nil,    37,    82,    21,    21,    73,    21,   nil,    73,    73,
    73,    73,    63,   nil,    38,    63,    63,    63,    63,    63,
    63,    63,    63,    94,    47,    94,    39,    47,    47,    47,
    47,    47,    47,    47,    47,    47,    47,    47,    47,    47,
    47,    47,    47,    47,    47,    54,    76,    54,    76,    47,
    54,    54,    54,    54,    54,    54,    54,    54,    54,    54,
    54,    54,    54,    54,    54,    54,    54,    54,    95,   nil,
   nil,    95,    95,    95,    95,    95,    95,    95,    95,    95,
    95,    95,    95,    95,    95,    95,    95,    95,    95,    78,
   nil,   nil,    78,    78,    78,    78,    78,    78,    78,    78,
    78,    78,    78,    78,    78,    78,    78,    78,    78,    78,
     3,   nil,   nil,     3,     3,     3,     3,     3,     3,     3,
     3,     3,     3,     3,     3,     3,     3,     3,     3,     3,
     3,    74,   nil,   nil,    74,    74,    74,    74,    74,    74,
    74,    74,    74,    74,    74,    74,    74,    74,    74,    74,
    74,    74,    56,   nil,   nil,    56,    56,    56,    56,    56,
    56,    56,    56,    56,    56,    56,    56,    56,    56,    56,
    56,    56,    56,    77,   nil,   nil,    77,    77,    77,    77,
    77,    77,    77,    77,    77,    77,    77,    77,    77,    77,
    77,    77,    77,    77,    58,   nil,   nil,    58,    58,    58,
    58,    58,    58,    58,    58,    58,    58,    58,    58,    58,
    58,    58,    58,    58,    68,   nil,   nil,    68,    68,    68,
    68,    68,    68,    68,    68,    68,    68,    68,    68,    68,
    68,    68,    68,    59,   nil,   nil,    59,    59,    59,    59,
    59,    59,    59,    59,    59,    59,    59,    59,    59,    59,
    59,    59,    69,   nil,   nil,    69,    69,    69,    69,    69,
    69,    69,    69,    69,    69,    69,    69,    69,    69,    69,
    69,    61,   nil,   nil,    61,    61,    61,    61,    61,    61,
    61,    61,    61,    61,    61,    61,    60,   nil,   nil,    60,
    60,    60,    60,    60,    60,    60,    60,    60,    60,    60,
    60,    64,   nil,   nil,    64,    64,    64,    64,    64,    64,
    64,    64,    65,   nil,   nil,    65,    65,    65,    65,    65,
    65,    65,    65,    62,   nil,   nil,    62,    62,    62,    62,
    62,    62,    62,    62,    71,   nil,   nil,    71,    71,    71,
    71,    71,    71,    70,   nil,   nil,    70,    70,    70,    70,
    70,    70,    67,   nil,   nil,    67,    67,    67,    67,    72,
   nil,   nil,    72,    72,    72,    72,    66,   nil,   nil,    66,
    66,    66,    66 ]

racc_action_pointer = [
    -2,   101,    22,   414,   nil,   nil,   nil,   nil,    52,   nil,
   nil,   nil,   nil,    35,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   286,   nil,    64,   146,    25,   158,   102,   170,   183,
   195,   207,   220,   232,   244,   257,   269,   281,   294,   306,
   nil,   nil,    72,    84,    96,   109,   121,   328,   133,    47,
   nil,     1,    10,    22,   351,   nil,   456,    25,   498,   537,
   590,   575,   627,   316,   605,   616,   670,   656,   518,   556,
   647,   638,   663,   309,   435,   nil,   327,   477,   393,    61,
    39,   nil,   280,   nil,    77,   nil,    22,   nil,    59,   -38,
   nil,    90,   nil,    96,   304,   372,     1,   nil,   nil,   nil,
   nil ]

racc_action_default = [
    -1,   -61,    -2,    -3,    -6,    -7,    -8,    -9,   -10,   -11,
   -12,   -13,   -14,   -61,   -16,   -17,   -18,   -19,   -20,   -21,
   -22,   -23,   -48,   -61,   -61,   -61,    -5,   -61,   -61,   -61,
   -61,   -61,   -61,   -61,   -61,   -61,   -61,   -61,   -61,   -61,
   -42,   -43,   -61,   -61,   -61,   -61,   -61,   -61,   -27,   -61,
   -51,   -54,   -61,   -61,   -61,   101,    -4,   -25,   -30,   -31,
   -32,   -33,   -34,   -35,   -36,   -37,   -38,   -39,   -40,   -41,
   -44,   -45,   -46,   -47,   -50,   -15,   -61,   -28,   -49,   -54,
   -61,   -55,   -61,   -57,   -61,   -59,   -27,   -24,   -61,   -61,
   -53,   -61,   -60,   -61,   -61,   -29,   -61,   -56,   -58,   -26,
   -52 ]

racc_goto_table = [
    26,    47,     2,    76,     1,   nil,    50,    80,   nil,   nil,
   nil,   nil,    54,   nil,    56,   nil,    58,    59,    60,    61,
    62,    63,    64,    65,    66,    67,    68,    69,   nil,   nil,
    70,    71,    72,    73,    74,    89,    77,    78,    83,    85,
   nil,    94,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    82,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    90,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    77,   nil,    95,   nil,    98,   nil,
    26,   100 ]

racc_goto_check = [
     4,     3,     2,    13,     1,   nil,    14,    15,   nil,   nil,
   nil,   nil,     3,   nil,     3,   nil,     3,     3,     3,     3,
     3,     3,     3,     3,     3,     3,     3,     3,   nil,   nil,
     3,     3,     3,     3,     3,    15,     3,     3,    14,    14,
   nil,    13,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,     2,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    14,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,     3,   nil,     3,   nil,    14,   nil,
     4,    14 ]

racc_goto_pointer = [
   nil,     4,     2,   -12,    -2,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   -45,   -15,   -44 ]

racc_goto_default = [
   nil,   nil,   nil,     3,     4,     5,     6,     7,     8,     9,
    10,    11,    12,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 44, :_reduce_1,
  1, 44, :_reduce_2,
  1, 45, :_reduce_3,
  3, 45, :_reduce_4,
  2, 45, :_reduce_5,
  1, 45, :_reduce_6,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  1, 46, :_reduce_none,
  3, 46, :_reduce_15,
  1, 47, :_reduce_none,
  1, 47, :_reduce_none,
  1, 48, :_reduce_18,
  1, 48, :_reduce_19,
  1, 48, :_reduce_20,
  1, 48, :_reduce_21,
  1, 48, :_reduce_22,
  1, 49, :_reduce_23,
  4, 49, :_reduce_24,
  3, 49, :_reduce_25,
  6, 49, :_reduce_26,
  0, 56, :_reduce_27,
  1, 56, :_reduce_28,
  3, 56, :_reduce_29,
  3, 50, :_reduce_30,
  3, 50, :_reduce_31,
  3, 50, :_reduce_32,
  3, 50, :_reduce_33,
  3, 50, :_reduce_34,
  3, 50, :_reduce_35,
  3, 50, :_reduce_36,
  3, 50, :_reduce_37,
  3, 50, :_reduce_38,
  3, 50, :_reduce_39,
  3, 50, :_reduce_40,
  3, 50, :_reduce_41,
  2, 50, :_reduce_42,
  2, 50, :_reduce_43,
  3, 50, :_reduce_44,
  3, 50, :_reduce_45,
  3, 50, :_reduce_46,
  3, 50, :_reduce_47,
  1, 51, :_reduce_48,
  3, 52, :_reduce_49,
  3, 52, :_reduce_50,
  2, 53, :_reduce_51,
  6, 53, :_reduce_52,
  4, 53, :_reduce_53,
  0, 58, :_reduce_54,
  1, 58, :_reduce_55,
  3, 58, :_reduce_56,
  3, 54, :_reduce_57,
  5, 54, :_reduce_58,
  3, 55, :_reduce_59,
  3, 57, :_reduce_60 ]

racc_reduce_n = 61

racc_shift_n = 101

racc_token_table = {
  false => 0,
  :error => 1,
  :IF => 2,
  :ELSE => 3,
  :CLASS => 4,
  :EXTENDS => 5,
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
  "EXTENDS" => 17,
  "!" => 18,
  "++" => 19,
  "--" => 20,
  "+=" => 21,
  "-=" => 22,
  "*" => 23,
  "/" => 24,
  "+" => 25,
  "-" => 26,
  ">" => 27,
  ">=" => 28,
  "<" => 29,
  "<=" => 30,
  "==" => 31,
  "!=" => 32,
  "*=" => 33,
  "/=" => 34,
  "&&" => 35,
  "||" => 36,
  "=" => 37,
  ":" => 38,
  "," => 39,
  "(" => 40,
  ")" => 41,
  ";" => 42 }

racc_nt_base = 43

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
  "\"+=\"",
  "\"-=\"",
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
  "\"*=\"",
  "\"/=\"",
  "\"&&\"",
  "\"||\"",
  "\"=\"",
  "\":\"",
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
  "FunctionDeclaration",
  "Class",
  "If",
  "ArgList",
  "Block",
  "ParamList" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'grammar.y', 29)
  def _reduce_1(val, _values, result)
     result = Nodes.new([]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 30)
  def _reduce_2(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 34)
  def _reduce_3(val, _values, result)
     result = Nodes.new(val) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 35)
  def _reduce_4(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 36)
  def _reduce_5(val, _values, result)
     result = val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 37)
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

module_eval(<<'.,.,', 'grammar.y', 49)
  def _reduce_15(val, _values, result)
     result = val[1] 
    result
  end
.,.,

# reduce 16 omitted

# reduce 17 omitted

module_eval(<<'.,.,', 'grammar.y', 58)
  def _reduce_18(val, _values, result)
     result = NumberNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 59)
  def _reduce_19(val, _values, result)
     result = StringNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 60)
  def _reduce_20(val, _values, result)
     result = TrueNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 61)
  def _reduce_21(val, _values, result)
     result = FalseNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 62)
  def _reduce_22(val, _values, result)
     result = NullNode.new 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 66)
  def _reduce_23(val, _values, result)
     result = CallNode.new(nil, val[0], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 67)
  def _reduce_24(val, _values, result)
     result = CallNode.new(nil, val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 68)
  def _reduce_25(val, _values, result)
     result = CallNode.new(val[0], val[2], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 70)
  def _reduce_26(val, _values, result)
     result = CallNode.new(val[0], val[2], val[4]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 74)
  def _reduce_27(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 75)
  def _reduce_28(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 76)
  def _reduce_29(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 80)
  def _reduce_30(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 81)
  def _reduce_31(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 82)
  def _reduce_32(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 83)
  def _reduce_33(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 84)
  def _reduce_34(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 85)
  def _reduce_35(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 86)
  def _reduce_36(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 87)
  def _reduce_37(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 88)
  def _reduce_38(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 89)
  def _reduce_39(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 90)
  def _reduce_40(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 91)
  def _reduce_41(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 92)
  def _reduce_42(val, _values, result)
     result = CallNode.new(val[0], val[1], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 93)
  def _reduce_43(val, _values, result)
     result = CallNode.new(val[0], val[1], []) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 94)
  def _reduce_44(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 95)
  def _reduce_45(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 96)
  def _reduce_46(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 97)
  def _reduce_47(val, _values, result)
     result = CallNode.new(val[0], val[1], [val[2]]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 101)
  def _reduce_48(val, _values, result)
     result = GetConstantNode.new(val[0]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 105)
  def _reduce_49(val, _values, result)
     result = SetLocalNode.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 106)
  def _reduce_50(val, _values, result)
     result = SetConstantNode.new(val[0], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 110)
  def _reduce_51(val, _values, result)
     result = DefNode.new(val[0], [], val[1]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 112)
  def _reduce_52(val, _values, result)
     result = DefNode.new(val[0], val[3], val[5]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 113)
  def _reduce_53(val, _values, result)
     result = DefNode.new(val[0], val[2], val[3]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 117)
  def _reduce_54(val, _values, result)
     result = [] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 118)
  def _reduce_55(val, _values, result)
     result = val 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 119)
  def _reduce_56(val, _values, result)
     result = val[0] << val[2] 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 123)
  def _reduce_57(val, _values, result)
     result = ClassNode.new(val[1], val[2], nil) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 124)
  def _reduce_58(val, _values, result)
     result = ClassNode.new(val[1], val[4], val[3]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 128)
  def _reduce_59(val, _values, result)
     result = IfNode.new(val[1], val[2]) 
    result
  end
.,.,

module_eval(<<'.,.,', 'grammar.y', 132)
  def _reduce_60(val, _values, result)
     result = val[1] 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

end   # class Parser

end
