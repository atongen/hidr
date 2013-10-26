# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cript/version'

Gem::Specification.new do |spec|
  spec.name          = "cript"
  spec.version       = Cript::VERSION
  spec.authors       = ["Andrew Tongen"]
  spec.email         = ["atongen@gmail.com"]
  spec.description   = %q{Simple encryption tools}
  spec.summary       = %q{Simple encryption tools}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
