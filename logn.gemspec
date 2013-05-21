# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'logn/version'

Gem::Specification.new do |spec|
  spec.name          = "logn"
  spec.version       = Logn::VERSION
  spec.authors       = ["Marten Veldthuis"]
  spec.email         = ["marten@veldthuis.com"]
  spec.description   = %q{Logn parses and filters log files}
  spec.summary       = %q{With Logn you can easily grep through formatted logfiles to search and correlate entries.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
