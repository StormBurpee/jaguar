require_relative "parser"
require_relative "runtime"

module Jaguar

  class Compiler
    def initialize
      @parser = Parser.new
    end

    def eval(code)
      @parser.parse(code).eval(Runtime)
    end
  end

  class Nodes
    def compile(context)
      return_value = nil

      nodes.each do |node|
        return_value = node.eval(context)
      end

      return_value || "/* empty */"
    end
  end

  class NumberNode
    def compile(context)

    end
  end

  class StringNode
    def compile(context)

    end
  end

  class TrueNode
    def compile(context)

    end
  end

  class FalseNode
    def compile(context)

    end
  end

  class NullNode
    def compile(context)

    end
  end

  class CallNode
    def compile(context)

    end
  end

  class GetConstantNode
    def compile(context)

    end
  end

  class SetConstantNode
    def compile(context)

    end
  end

  class GetLocalNode
    def compile(context)

    end
  end

  class SetLocalNode
    def compile(context)

    end
  end

  class DefNode
    def compile(context)

    end
  end

  class ClassNode
    def compile(context)

    end
  end

  class IfNode
    def compile(context)

    end
  end

end
