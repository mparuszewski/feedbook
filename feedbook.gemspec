# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'feedbook/version'

Gem::Specification.new do |spec|
  spec.name          = 'feedbook'
  spec.version       = Feedbook::VERSION
  spec.authors       = ['Maciej Paruszewski']
  spec.email         = ['maciek.paruszewski@gmail.com']
  spec.summary       = %q{Feedbook}
  spec.homepage      = "https://github.com/pinoss/feedbook"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'feedjira', '~> 1.3'
  spec.add_runtime_dependency 'gli',      '~> 2.1'
  spec.add_runtime_dependency 'liquid',   '~> 2.6'
  spec.add_runtime_dependency 'timeloop', '~> 1.0'
  spec.add_runtime_dependency 'koala',    '~> 1.9'
  spec.add_runtime_dependency 'box',      '~> 0.1'
  spec.add_runtime_dependency 'twitter',  '~> 5.1'
  spec.add_runtime_dependency 'mail',     '~> 2.6'
  spec.add_runtime_dependency 'irc-notify'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake',    '~> 10.3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry-debugger'
end
