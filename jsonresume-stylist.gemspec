# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonresume/stylist/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonresume-stylist"
  spec.version       = JSONResume::Stylist::VERSION
  spec.authors       = ["Nino Miletich"]
  spec.email         = ["nino@miletich.me"]

  spec.required_ruby_version = ">= 2.0"

  spec.summary       = %q{Small framework for making jsonresume themes in liquid and scss.}
  spec.homepage      = "https://github.com/omninonsense/jsonresume-stylist"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = ["jsonresume-stylist"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"

  spec.add_dependency "yajl-ruby", "~> 1.0"
  spec.add_dependency "oga", "~> 2.0"
  spec.add_dependency "sass", "~> 3.0"
  spec.add_dependency "liquid", "~> 3.0"

end
