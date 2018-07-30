module Jaguar
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
  Runtime["Number"].runtime_methods["+="] = proc do |receiver, arguments|
    receiver.ruby_value += arguments.first.ruby_value
    Runtime["Number"].new_with_value(receiver.ruby_value)
  end
  Runtime["Number"].runtime_methods["-="] = proc do |receiver, arguments|
    receiver.ruby_value -= arguments.first.ruby_value
    Runtime["Number"].new_with_value(receiver.ruby_value)
  end
  Runtime["Number"].runtime_methods["*="] = proc do |receiver, arguments|
    receiver.ruby_value = receiver.ruby_value * arguments.first.ruby_value
    Runtime["Number"].new_with_value(receiver.ruby_value)
  end
  Runtime["Number"].runtime_methods["/="] = proc do |receiver, arguments|
    receiver.ruby_value = receiver.ruby_value / arguments.first.ruby_value
    Runtime["Number"].new_with_value(receiver.ruby_value)
  end
  Runtime["Number"].runtime_methods["++"] = proc do |receiver, arguments|
    receiver.ruby_value += 1;
    Runtime["Number"].new_with_value(receiver.ruby_value)
  end
  Runtime["Number"].runtime_methods["--"] = proc do |receiver, arguments|
    receiver.ruby_value -= 1;
    Runtime["Number"].new_with_value(receiver.ruby_value)
  end
end
