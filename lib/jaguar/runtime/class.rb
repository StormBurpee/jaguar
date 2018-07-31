module Jaguar

  class JaguarClass < JaguarObject
    attr_reader :runtime_methods, :static_methods, :runtime_superclass, :classname

    def initialize(superclass = nil)
      @runtime_methods = {}
      @static_methods = {}
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

    def lookup_static(method_name, object = false)
      puts "checking for #{method_name}, in #{@static_methods}"
      method = @static_methods[method_name]
      unless method
        if @runtime_superclass
          puts "checking parent"
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

    def new
      JaguarObject.new(self)
    end

    def new_with_value(value)
      JaguarObject.new(self, value)
    end
  end

end
