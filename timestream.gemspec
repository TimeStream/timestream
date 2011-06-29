# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "timestream/version"

Gem::Specification.new do |s|
  s.name        = "timestream"
  s.version     = Timestream::VERSION
  s.authors     = ["Ahmad Varoqua"]
  s.email       = ["ahmadvaroqua@timestreamapp.com"]
  s.homepage    = "https://timestreamapp.com"
  s.summary     = %q{This is a command line interface to the TimeStream web application.}
  s.description = %q{This is a command line interface to the TimeStream web application.}

  s.rubyforge_project = "timestream"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.executables   = ['ts']
  s.require_paths = ["lib"]

  s.add_dependency "thor"
  s.add_dependency "json"
  s.add_dependency "httparty"
end
