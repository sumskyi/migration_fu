# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "migration-foo"
  s.version     = Migration::Fu::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["me"]
  s.email       = ["sumskyi@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{fks}
  s.description = %q{foreign keys support for MySQL}

  s.rubyforge_project = "sumskyi-migration-fu"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
