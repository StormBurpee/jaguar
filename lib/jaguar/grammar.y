class Parser

token IF ELSE
token DEF
token CLASS
token NEWLINE
token NUMBER STRING
token TRUE FALSE NULL
token IDENTIFIER CONSTANT
token INDENT DEDENT

prechigh
  left  '.'
  right '!'
  left  '*' '/'
  left  '+' '-'
  left  '>' '>=' '<' '<='
  left  '==' '!='
  left  '&&'
  left  '||'
  right '='
  left  ','
preclow

rule
  Root:
    /* nothing */                         { result = Nodes.new([]) }
  | Expressions                           { result = val[0] }
  ;

  Expressions:
    Expression                            { result = Nodes.new(val) }
  | Expressions Terminator Expression     { result = val[0] << val[2] }
  | Expressions Terminator                { result = val[0] }
  | Terminator                            { result = Nodes.new([]) }
  ;

  Expression:
    Literal
  | Call
  | Operator
  | Constant
  | Assign
  | Def
  | Class
  | If
  | '(' Expression ')'                    { result = val[1] }
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
  | Expression '.' IDENTIFIER             { result = CallNode.new(val[0], val[2], []) }
  | Expression '.' IDENTIFIER
    '(' ArgList ')'                       { result = CallNode.new(val[0], val[2], val[4]) }
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
  | Constant "=" Expression               { result = SetConstantNode.new(val[0], val[2]) }
  ;

  Def:
    DEF IDENTIFIER Block                  { result = DefNode.new(val[1], [], val[2]) }
  | DEF IDENTIFIER
    "(" ParamList ")" Block               { result = DefNode.new(val[1], val[3], val[5]) }
  ;

  ParamList:
    /* nothing */                         { result = [] }
  | IDENTIFIER                            { result = val }
  | ParamList "," IDENTIFIER              { result = val[0] << val[2] }
  ;

  Class:
    CLASS CONSTANT Block                  { result = ClassNode.new(val[1], val[2]) }
  ;

  If:
    IF Expression Block                   { result = IfNode.new(val[1], val[2]) }
  ;

  Block:
    INDENT Expressions DEDENT             { result = val[1] }
  ;

end

---- header
  require "lexer"
  require "nodes"

---- inner
  def parse(code, show_tokens=false)
    @tokens = Lexer.new.tokenize(code)
    puts @tokens.inspect if show_tokens
    do_parse
  end

  def next_token
    @tokens.shift
  end
