# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'g5_authenticatable_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'g5_authenticatable_api'
  spec.version       = G5AuthenticatableApi::VERSION
  spec.authors       = ['maeve']
  spec.email         = ['maeve.revels@getg5.com']
  spec.summary       = 'Helpers for securing APIs with G5'
  spec.description   = %q{A set of helpers for securing a Rack-based API
                          with G5 Auth using token-based authentication.}
  spec.homepage      = 'https://github.com/g5search/g5_authenticatable_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'g5_authentication_client', '~> 0.2'
end
