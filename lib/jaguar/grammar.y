class Parser

token IF ELSE
token CLASS EXTENDS SUPER
token STATIC THIS NEW
token NEWLINE
token NUMBER STRING
token TRUE FALSE NULL
token IDENTIFIER CONSTANT
token INDENT DEDENT
token RETURN

prechigh
  left  '.' EXTENDS STATIC THIS
  right '!'
  nonassoc '++' '--' '+=' '-='
  left  '*' '/'
  left  '+' '-'
  left  '>' '>=' '<' '<='
  left  '==' '!='
  right '+=' '-=' '*=' '/='
  left  '&&'
  left  '||'
  right '=' ':'
  right SUPER CONSTANT
  left  ','
preclow

expect 1

rule
  Root:
    /* nothing */                         { result = Nodes.new([], false, nil) }
  | Expressions                           { result = val[0] }
  ;

  Expressions:
    Expression                            { result = Nodes.new(val, false, nil) }
  | Expressions Terminator Expression     { result = val[0] << val[2] }
  | Expressions Terminator                { result = val[0] }
  | Terminator                            { result = Nodes.new([], false, nil) }
  | Statements                            { result = Nodes.new(val, false, nil) }
  ;

  Expression:
    Literal
  | Call
  | This
  | Operator
  | Constant
  | Assign
  | Super
  | FunctionDeclaration
  | New
  | Class
  | If
  | '(' Expression ')'                    { result = val[1] }
  ;

  /* later on implement import/export here */
  Statements:
    Return
  ;

  Return:
    RETURN Expression                     { result = ReturnNode.new(val[1]) }
  ;

  Terminator:
    NEWLINE
  | ';'
  ;

  Literal:
    NUMBER                                { result = NumberNode.new(val[0]) }
  | STRING                                { result = StringNode.new(val[0]) }
  | TRUE                                  { result = TrueNode.new }
  | FALSE                                 { result = FalseNode.new }
  | NULL                                  { result = NullNode.new }
  ;

  Call:
    IDENTIFIER                            { result = CallNode.new(nil, val[0], []) }
  | IDENTIFIER '(' ArgList ')'            { result = CallNode.new(nil, val[0], val[2]) }
  | CONSTANT '.' IDENTIFIER               { result = StaticCallNode.new(val[0], val[2], [], true)}
  | CONSTANT '.' IDENTIFIER
    '(' ArgList ')'                       { result = StaticCallNode.new(val[0], val[2], val[4], true) }
  | Expression '.' IDENTIFIER             { result = CallNode.new(val[0], val[2], [], true) }
  | Expression '.' IDENTIFIER
    '(' ArgList ')'                       { result = CallNode.new(val[0], val[2], val[4], true) }
  ;

  This:
    THIS IDENTIFIER                       { result = ThisCallNode.new(val[1], nil) }
  | THIS IDENTIFIER '(' ArgList ')'       { result = ThisCallNode.new(val[1], val[3]) }
  ;

  ArgList:
    /* nothing */                         { result = [] }
  | Expression                            { result = val }
  | ArgList ',' Expression                { result = val[0] << val[2] }
  ;

  Operator:
    Expression '||' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '&&' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '==' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '!=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '>'  Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '>=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '<'  Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '<=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '+=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '-=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '*=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '/=' Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '++'                       { result = CallNode.new(val[0], val[1], []) }
  | Expression '--'                       { result = CallNode.new(val[0], val[1], []) }
  | Expression '+'  Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '-'  Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '*'  Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  | Expression '/'  Expression            { result = CallNode.new(val[0], val[1], [val[2]]) }
  ;

  Constant:
    CONSTANT                              { result = GetConstantNode.new(val[0]) }
  ;

  Assign:
    IDENTIFIER '=' Expression             { result = SetLocalNode.new(val[0], val[2]) }
  | THIS IDENTIFIER '=' Expression        { result = SetLocalThisNode.new(val[1], val[3]) }
  | Constant "=" Expression               { result = SetConstantNode.new(val[0], val[2]) }
  ;

  New:
    NEW CONSTANT                          { result = NewNode.new(val[1], nil) }
  | NEW CONSTANT "(" ArgList ")"          { result = NewNode.new(val[1], val[3]) }
  ;

  Super:
    SUPER "(" ArgList ")"                 { result = SuperNode.new(val[2]) }
  ;

  FunctionDeclaration:
    IDENTIFIER Block                      { result = DefNode.new(val[0], [], val[1], false) }
  | IDENTIFIER ":"
    "(" ParamList ")" Block               { result = DefNode.new(val[0], val[3], val[5], false) }
  | IDENTIFIER ":" ParamList Block        { result = DefNode.new(val[0], val[2], val[3], false) }
  | STATIC IDENTIFIER Block               { result = DefNode.new(val[1], [], val[2], true) }
  | STATIC IDENTIFIER ":"
    "(" ParamList ")" Block               { result = DefNode.new(val[1], val[4], val[6], true) }
  | STATIC IDENTIFIER ":" ParamList Block { result = DefNode.new(val[1], val[3], val[4], true) }
  ;

  ParamList:
    /* nothing */                         { result = [] }
  | IDENTIFIER                            { result = val }
  | ParamList "," IDENTIFIER              { result = val[0] << val[2] }
  ;

  Class:
    CLASS CONSTANT Block                  { result = ClassNode.new(val[1], val[2], nil) }
  | CLASS CONSTANT EXTENDS CONSTANT Block { result = ClassNode.new(val[1], val[4], val[3]) }
  ;

  If:
    IF Expression Block                   { result = IfNode.new(val[1], val[2]) }
  ;

  Block:
    INDENT Expressions DEDENT             { result = val[1] }
  ;

end

---- header
require_relative "lexer"
require_relative "nodes"
require_relative "parse_error"

module Jaguar

---- inner
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

---- footer
end
