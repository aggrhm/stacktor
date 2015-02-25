# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stacktor/version'

Gem::Specification.new do |spec|
  spec.name          = "stacktor"
  spec.version       = Stacktor::VERSION
  spec.authors       = ["Alan Graham"]
  spec.email         = ["alan@productlab.com"]
  spec.summary       = %q{A more structured gem for communicating with OpenStack.}
  spec.description   = %q{A more structured gem for communicating with OpenStack.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
