module Jaguar
  class Nodes < Struct.new(:nodes, :returnnode, :returnvalue)
    def <<(node)
      nodes << node
      self
    end

    def return_node(returnvalue)
      @returnvalue = returnvalue
      @returnnode = true
    end
  end

  class LiteralNode < Struct.new(:value); end
  class NumberNode < LiteralNode; end
  class StringNode < LiteralNode; end

  class TrueNode < LiteralNode
    def initialize
      super(true)
    end
  end

  class FalseNode < LiteralNode
    def initialize
      super(false)
    end
  end

  class NullNode < LiteralNode
    def initialize
      super(nil)
    end
  end

  class CallNode < Struct.new(:receiver, :method, :arguments, :accessor); end
  class ThisCallNode < Struct.new(:identifier, :arguments); end
  class StaticCallNode < Struct.new(:receiver, :method, :arguments, :accessor); end
  class GetConstantNode < Struct.new(:name); end
  class SetConstantNode < Struct.new(:name, :value); end
  class GetLocalNode < Struct.new(:name); end
  class SetLocalNode < Struct.new(:name, :value); end
  class SetLocalThisNode < Struct.new(:name, :value); end

  class DefNode < Struct.new(:name, :params, :body, :static); end
  class ClassNode < Struct.new(:name, :body, :extends); end
  class SuperNode < Struct.new(:arguments); end
  class NewNode < Struct.new(:classname, :arguments); end

  class ReturnNode < Struct.new(:returnval); end

  class IfNode < Struct.new(:condition, :body); end
end
