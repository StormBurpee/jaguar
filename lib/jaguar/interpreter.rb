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
      method = JaguarMethod.new(params, body, name)
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
        unless extends.nil?
          parent_class = context[extends]
          unless parent_class
            raise "Class #{name} is trying to extend Class #{extends}, but Class #{extends} doesn't exist!"
          end
          jaguar_class = JaguarClass.new(parent_class)
        else
          jaguar_class = JaguarClass.new
        end
        jaguar_class.set_class_name(name)
        context[name] = jaguar_class
      end

      # Creates a new scope for classes, so methods can be defined here
      # and not accessed globaly.
      class_context = Context.new(jaguar_class, jaguar_class)
      body.eval(class_context)

      jaguar_class
    end
  end

  class SuperNode
    def eval(context)
      unless context.current_class.runtime_superclass.method_exists(context.current_method)
        raise "#{context.current_method} does not exist in any parent classes of #{context.current_class.classname}."
      end
      method = context.current_class.runtime_superclass.lookup(context.current_method)
      eval_arguments = arguments.map { |arg| arg.eval(context) }
      method.call(context.current_class.runtime_superclass, eval_arguments)
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
