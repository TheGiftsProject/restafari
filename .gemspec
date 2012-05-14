# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "restafari/version"

Gem::Specification.new do |s|
  s.name        = "restafari"
  s.version     = Restafari::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Danni Friedland"]
  s.email       = [%w(dannifriedland@gmail.com)]
  s.homepage    = "https://github.com/TheGiftsProject/restafari"
  s.summary     = %q{A DSL for consuming RESTful apis}
  s.description = %q{Helper class to work with the restful apis}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = %w(lib)

  s.add_dependency "faraday"

  s.add_development_dependency "webmock"
  s.add_development_dependency "spork"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"

end