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

  require_relative "core/object"
  require_relative "core/number"
  require_relative "core/string"
  require_relative "core/bool"

end
