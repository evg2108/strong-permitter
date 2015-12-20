lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strong_permitter/version'

Gem::Specification.new do |spec|
  spec.name          = 'strong-permitter'
  spec.version       = StrongPermitter::VERSION
  spec.authors       = %w(evg2108)
  spec.email         = %w(evg2108@yandex.ru)
  spec.summary       = %q{It allows move params permissions from controllers to separated permission-objects}
  spec.description   = %q{It allows move params permissions from controllers to separated permission-objects}
  spec.homepage      = 'https://github.com/evg2108/strong-permitter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_dependency 'actionpack', '~> 4.0'
  spec.add_dependency 'railties', '~> 4.0'
end
