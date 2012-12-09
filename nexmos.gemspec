# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nexmos/version'

Gem::Specification.new do |gem|
  gem.name          = "nexmos"
  gem.version       = Nexmos::VERSION
  gem.authors       = ["Alexander Simonov"]
  gem.email         = ["alex@simonov.me"]
  gem.description   = %q{Nexmo API client}
  gem.summary       = %q{Nexmo API client}
  gem.homepage      = "https://github.com/simonoff/nexmos"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency('multi_json')
  gem.add_dependency('rash')
  gem.add_dependency('faraday')
  gem.add_dependency('faraday_middleware')
  gem.add_dependency('activesupport', '>= 3.0.0')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('webmock')
end
