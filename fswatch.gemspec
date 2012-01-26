# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fswatch/version"

Gem::Specification.new do |s|
  s.name        = "fswatch"
  s.version     = Fswatch::VERSION
  s.authors     = ["Wiktor Macura"]
  s.email       = ["wiktor@tumblr.com"]
  s.homepage    = "http://github.com/wkm/fswatch"
  s.summary     = %q{A program for triggering a script on file system change (on OS X)}
  s.description = %q{}

  s.rubyforge_project = "fswatch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency 'rb-fsevent'
  s.add_runtime_dependency 'trollop'
  s.add_runtime_dependency 'term-ansicolor'
end
