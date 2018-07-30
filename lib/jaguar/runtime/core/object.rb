module Jaguar
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
end
