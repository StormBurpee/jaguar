module Jaguar

  class JaguarClass < JaguarObject
    attr_reader :runtime_methods, :static_methods, :runtime_superclass, :classname, :local_variables, :static_variables

    def initialize(superclass = nil)
      @runtime_methods = {}
      @static_methods = {}
      @local_variables = {}
      @static_variables = {}
      @runtime_superclass = superclass
      @classname = ""

      if defined? Runtime
        runtime_class = Runtime['Class']
      else
        runtime_class = nil
      end

      super(runtime_class)
    end

    def set_class_name(classname)
      @classname = classname
    end

    def get_class_name()
      @classname
    end

    def lookup(method_name, object = false)
      method = @runtime_methods[method_name]
      unless method
        if @static_methods[method_name]
          method = @static_methods[method_name]
        elsif @runtime_superclass
          return @runtime_superclass.lookup(method_name)
        else
          if defined? Runtime and !object
            return Runtime['Object'].lookup(method_name, true)
          else
            raise "Method not found #{method_name}"
          end
        end
      end
      method
    end

    def set_local(name, value)
      @local_variables[name] = value;
    end

    def lookup_variable(variable)
      v = @local_variables[variable]
      unless v
        if @runtime_superclass
          return @runtime_superclass.lookup_variable(variable)
        else
          return nil
        end
      else
        return v
      end
    end

    def lookup_static(method_name, object = false)
      method = @static_methods[method_name]
      unless method
        if @runtime_superclass
          return @runtime_superclass.lookup_static(method_name)
        else
          raise "Method not found #{method_name}"
        end
      end
      method
    end

    def method_exists(method_name)
      m_exists = false
      method = @runtime_methods[method_name]
      unless method
        if @static_methods[method_name]
          return true
        else @runtime_superclass
          m_exists = @runtime_superclass.method_exists(method_name)
        end
      else
        return true
      end
      m_exists
    end

    def static_method_exists(method_name)
      m_exists = false
      method = @static_methods[method_name]
      unless method
        if @runtime_superclass
          m_exists = @runtime_superclass.static_method_exists(method_name)
        end
      else
        return true
      end
      m_exists
    end

    def variable_exists(variable)
      v = lookup_variable(variable)
      unless v
        return false
      end
      return true
    end

    def new
      JaguarObject.new(self)
    end

    def new_with_value(value)
      JaguarObject.new(self, value)
    end
  end

end
