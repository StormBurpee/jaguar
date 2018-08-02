module Jaguar

  class JaguarObject
    attr_accessor :runtime_class, :ruby_value, :context

    def initialize(runtime_class, ruby_value=self)
      @runtime_class = runtime_class
      @ruby_value = ruby_value
    end

    def call(method, arguments=[])
      @runtime_class.lookup(method).call(self, arguments)
    end

    def set_context(context)
      @context = context
    end
  end

end
