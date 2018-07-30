
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jaguar/lang/version"

Gem::Specification.new do |spec|
  spec.name          = "jaguar-lang"
  spec.version       = Jaguar::Lang::VERSION
  spec.authors       = ["Storm Burpee"]
  spec.email         = ["stormburpee@gmail.com"]

  spec.summary       = "Jaguar is a fast modern programming language that can also compile into JavaScript"
  spec.description   = "Jaguar provides a fast OOP programming environment, that compiles to JavaScript to enable use anywhere."
  spec.homepage      = "https://jaguar-lang.io"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = "jaguar"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end