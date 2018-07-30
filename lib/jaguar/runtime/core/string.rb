module Jaguar
  Runtime["String"].runtime_methods["+"] = proc do |receiver, arguments|
    Runtime["String"].new_with_value(receiver.ruby_value.to_s + arguments.first.ruby_value.to_s)
  end
end
