# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hrr_rb_relaxed_xml/version"

Gem::Specification.new do |spec|
  spec.name          = "hrr_rb_relaxed_xml"
  spec.version       = HrrRbRelaxedXML::VERSION
  spec.authors       = ["hirura"]
  spec.email         = ["hirura@gmail.com"]

  spec.summary       = %q{An REXML-based XML toolkit that can have multiple root elements}
  spec.description   = %q{An REXML-based XML toolkit that can have multiple root elements}
  spec.homepage      = "https://github.com/hirura/hrr_rb_relaxed_xml"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "rexml"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
end
