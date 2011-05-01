# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rabbit_manager/version"

Gem::Specification.new do |s|
  s.name        = "rabbit_manager"
  s.version     = RabbitManager::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["mixtli"]
  s.email       = ["mixtli@github.com"]
  s.homepage    = ""
  s.summary     = %q{Client for RabbitMQ management plugin}
  s.description = %q{Wrapper around management plugin REST api}

  s.rubyforge_project = "rabbit_manager"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
