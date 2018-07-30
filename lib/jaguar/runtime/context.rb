module Jaguar

  class Context
    attr_reader :locals, :current_self, :current_class

    @@constants = {}

    def initialize(current_self, current_class=current_self.runtime_class)
      @locals = {}
      @current_self = current_self
      @current_class = current_class
    end

    def [](name)
      @@constants[name]
    end

    def []=(name, value)
      @@constants[name] = value
    end
  end

end
