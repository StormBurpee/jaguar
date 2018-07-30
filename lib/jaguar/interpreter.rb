require_relative "parser"
require_relative "runtime"

module Jaguar

  class Interpreter
    def initialize
      @parser = Parser.new
    end

    def eval(code)
      @parser.parse(code).eval(Runtime)
    end
  end

  class Nodes
    def eval(context)
      return_value = nil

      nodes.each do |node|
        return_value = node.eval(context)
      end

      return_value || Runtime["null"]
    end
  end

  class NumberNode
    def eval(context)
      Runtime["Number"].new_with_value(value)
    end
  end

  class StringNode
    def eval(context)
      Runtime["String"].new_with_value(value)
    end
  end

  class TrueNode
    def eval(context)
      Runtime["true"]
    end
  end

  class FalseNode
    def eval(context)
      Runtime["false"]
    end
  end

  class NullNode
    def eval(context)
      Runtime["null"]
    end
  end

  class CallNode
    def eval(context)
      if receiver.nil? && context.locals[method] && arguments.empty?
        context.locals[method]
      else
        if receiver
          value = receiver.eval(context)
        else
          value = context.current_self
        end

        eval_arguments = arguments.map { |arg| arg.eval(context) }
        value.call(method, eval_arguments)
      end
    end
  end

  class GetConstantNode
    def eval(context)
      context[name]
    end
  end

  class SetConstantNode
    def eval(context)
      context[name] = value.eval(context)
    end
  end

  class GetLocalNode
    def eval(context)
      context.locals[name]
    end
  end

  class SetLocalNode
    def eval(context)
      context.locals[name] = value.eval(context)
    end
  end

  class DefNode
    def eval(context)
      method = JaguarMethod.new(params, body)
      context.current_class.runtime_methods[name] = method
    end
  end

  class ClassNode
    def eval(context)
      # TODO: Accessing Class Prototypes
      # Currently this allows reopening classes, exactly the same as ruby
      # When you change this to accessing prototypes, change here
      jaguar_class = context[name]

      unless jaguar_class
        jaguar_class = JaguarClass.new
        context[name] = jaguar_class
      end

      # Creates a new scope for classes, so methods can be defined here
      # and not accessed globaly.
      class_context = Context.new(jaguar_class, jaguar_class)
      body.eval(class_context)

      jaguar_class
    end
  end

  class IfNode
    def eval(context)
      if condition.eval(context).ruby_value
        body.eval(context)
      end
    end
  end

end
