module Jaguar

  jaguar_class = JaguarClass.new
  jaguar_class.runtime_class = jaguar_class
  object_class = JaguarClass.new
  object_class.runtime_class = jaguar_class

  Runtime = Context.new(object_class.new)

  Runtime["Class"] = jaguar_class
  Runtime["Object"] = object_class

  Runtime["Number"] = JaguarClass.new(Runtime["Object"])
  Runtime["Bool"] = JaguarClass.new(Runtime["Object"])
  Runtime["String"] = JaguarClass.new(Runtime["Object"])

  Runtime["true"] = Runtime["Bool"].new_with_value(true)
  Runtime["false"] = Runtime["Bool"].new_with_value(false)
  Runtime["null"] = Runtime["Bool"].new_with_value(nil)

  Runtime["Class"].runtime_methods["new"] = proc do |receiver, arguments|
    receiver.new
  end

  # Object Initializations
  Runtime["Object"].runtime_methods["print"] = proc do |receiver, arguments|
    puts arguments.first.ruby_value
    Runtime["null"]
  end
  Runtime["Object"].runtime_methods["to_string"] = proc do |receiver, arguments|
    puts receiver
    puts arguments
    Runtime["String"].new_with_value("")
  end
  Runtime["Object"].runtime_methods["=="] = proc do |receiver, arguments|
    Runtime["Bool"].new_with_value(receiver.ruby_value == arguments.first.ruby_value)
  end
  Runtime["Object"].runtime_methods["!="] = proc do |receiver, arguments|
    Runtime["Bool"].new_with_value(receiver.ruby_value != arguments.first.ruby_value)
  end

  #Number Initializations
  Runtime["Number"].runtime_methods["+"] = proc do |receiver, arguments|
    Runtime["Number"].new_with_value(receiver.ruby_value + arguments.first.ruby_value)
  end
  Runtime["Number"].runtime_methods["-"] = proc do |receiver, arguments|
    Runtime["Number"].new_with_value(receiver.ruby_value - arguments.first.ruby_value)
  end
  Runtime["Number"].runtime_methods["*"] = proc do |receiver, arguments|
    Runtime["Number"].new_with_value(receiver.ruby_value * arguments.first.ruby_value)
  end
  Runtime["Number"].runtime_methods["/"] = proc do |receiver, arguments|
    Runtime["Number"].new_with_value(receiver.ruby_value / arguments.first.ruby_value)
  end
  Runtime["Number"].runtime_methods["++"] = proc do |receiver, arguments|
    Runtime["Number"].new_with_value(receiver.ruby_value + 1)
  end
  Runtime["Number"].runtime_methods["--"] = proc do |receiver, arguments|
    Runtime["Number"].new_with_value(receiver.ruby_value - 1)
  end

end
