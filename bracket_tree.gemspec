# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bracket_tree"
  s.version     = '0.0.1'
  s.authors     = ["Andrew Nordman"]
  s.email       = ["cadwallion@gmail.com"]
  s.homepage    = "https://github.com/agoragames/bracket_tree"
  s.summary     = %q{Binary Tree-based bracketing system}
  s.description = %q{Binary Tree-based bracketing system}

  s.rubyforge_project = "bracket_tree"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end
