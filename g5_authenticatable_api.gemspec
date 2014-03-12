# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'g5_authenticatable_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'g5_authenticatable_api'
  spec.version       = G5AuthenticatableApi::VERSION
  spec.authors       = ['Maeve Revels']
  spec.email         = ['maeve.revels@getg5.com']
  spec.summary       = 'Helpers for securing APIs with G5'
  spec.description   = 'Helpers for securing APIs with G5'
  spec.homepage      = 'https://github.com/G5/g5_authenticatable_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'g5_authentication_client', '~> 0.2'
end
