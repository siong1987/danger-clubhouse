# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clubhouse/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'danger-clubhouse'
  spec.version       = Clubhouse::VERSION
  spec.authors       = ['siong1987']
  spec.email         = ['siong1987@gmail.com']
  spec.description   = 'A danger.systems plugin that links to your clubhouse stories.'
  spec.summary       = 'A danger.systems plugin that links to your clubhouse stories.'
  spec.homepage      = 'https://github.com/siong1987/danger-clubhouse'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop', '~> 0.41'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'listen', '~> 3.1'
  spec.add_development_dependency 'pry', '~> 0.10'
end
