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
        if @returnnode == true
          return_value = @returnvalue
          break
        end
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
        if accessor
          if value.runtime_class
            if value.runtime_class.variable_exists(method)
              v = value.runtime_class.lookup_variable(method)
              return v.eval(value.runtime_class.context)
            end
          end
        end
        eval_arguments = arguments.map { |arg| arg.eval(context) }
        value.call(method, eval_arguments)
      end
    end
  end

  # TODO: THIS IS BROKEN FOR WHEN CALLING METHODS IN A CLASS
  class ThisCallNode
    def eval(context)
      if context.current_class.variable_exists(identifier)
        v = context.current_class.lookup_variable(identifier)
        return v.eval(context)
      else
        if context.current_class.method_exists(identifier)
          m = context.current_class.lookup(identifier)
          eval_arguments = arguments.map { |arg| arg.eval(context) }
          return m.call(context.current_class, eval_arguments)
        end
      end
    end
  end

  class StaticCallNode
    def eval(context)
      if receiver.nil? && context.locals[method] && arguments.empty?
        context.locals[method]
      else
        if context[receiver]
          mc = context[receiver]
          unless mc.static_method_exists(method)
            raise "Static method #{method} does not exists on class."
          end
          lm = mc.lookup_static(method)
          eval_arguments = arguments.map { |arg| arg.eval(context) }

          lm.call(context[receiver], eval_arguments)
          #value = context.current_self
        else
          raise "Static Call Called on a non Static Item"
        end
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

  class SetLocalThisNode
    def eval(context)
      context.current_class.set_local(name, value.eval(context))
    end
  end

  class DefNode
    def eval(context)
      method = JaguarMethod.new(params, body, name)
      unless static
        context.current_class.runtime_methods[name] = method
      else
        context.current_class.static_methods[name] = method
      end
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

      jaguar_class.set_context(class_context)

      jaguar_class
    end
  end

  class SuperNode
    def eval(context)
      unless context.current_class.runtime_superclass.method_exists(context.current_method.name)
        raise "#{context.current_method.name} does not exist in any parent classes of #{context.current_class.classname}."
      end
      method = context.current_class.runtime_superclass.lookup(context.current_method.name)
      eval_arguments = arguments.map { |arg| arg.eval(context) }
      method.call(context.current_class.runtime_superclass, eval_arguments)
    end
  end

  class NewNode
    def eval(context)
      unless context[classname].is_a?(JaguarClass)
        raise "'new' can only be used with type of 'Class'."
      end

      jaguar_class = context[classname]
      jaguar_class_nc = jaguar_class.new

      if jaguar_class.method_exists("init")
        jaguar_class.lookup("init").call(jaguar_class_nc, arguments);
      end
      jaguar_class_nc
    end
  end

  class ReturnNode
    def eval(context)
      method = context.current_method
      method.body.return_node(returnval.eval(context))
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
