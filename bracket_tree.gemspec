# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bracket_tree"
  s.version     = '0.1.0'
  s.authors     = ["Andrew Nordman"]
  s.email       = ["anordman@majorleaguegaming.com"]
  s.homepage    = "https://github.com/agoragames/bracket_tree"
  s.summary     = %q{Binary Tree based bracketing system}
  s.description = %q{Binary Tree based bracketing system}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", '2.99'
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rake"
end
