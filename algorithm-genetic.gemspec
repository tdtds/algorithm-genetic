# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'algorithm/genetic/version'

Gem::Specification.new do |spec|
  spec.name          = "algorithm-genetic"
  spec.version       = Algorithm::Genetic::VERSION
  spec.authors       = ["TADA Tadashi"]
  spec.email         = ["t@tdtds.jp"]
  spec.summary       = %q{A Generic Algorithm Library for Ruby Language}
  spec.description   = %q{A Generic Algorithm Library for Ruby Language}
  spec.homepage      = ""
  spec.license       = "GPL"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
