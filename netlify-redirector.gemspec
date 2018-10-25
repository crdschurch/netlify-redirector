lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netlify-redirector/version'

Gem::Specification.new do |s|
  s.name        = 'netlify-redirector'
  s.version     = NetlifyRedirector::VERSION
  s.licenses    = ['BSD-3']
  s.summary     = "ENV-specific redirects on Netlify"
  s.authors     = ["Ample"]
  s.email       = 'taylor@helloample.com'
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]
  s.add_dependency 'activesupport'
end