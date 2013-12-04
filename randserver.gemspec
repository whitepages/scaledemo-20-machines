# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'randserver/version'

Gem::Specification.new do |spec|
  spec.name          = "randserver"
  spec.version       = Randserver::VERSION
  spec.authors       = ["Jeffrey Hulten"]
  spec.email         = ["jhulten@whitepages.com"]
  spec.description   = %q{Generates Random Numbers}
  spec.summary       = %q{Generate lots of random numbers}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "riemann-client"
  spec.add_dependency "celluloid"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "fpm"
end
