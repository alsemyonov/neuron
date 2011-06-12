# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'neuron/version'

Gem::Specification.new do |s|
  s.name        = 'neuron'
  s.version     = Neuron::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alexander Semyonov']
  s.email       = ['al@semyonov.us']
  s.homepage    = ''
  s.summary     = %q{Tools for decrease code duplication in rails applications}
  s.description = %q{Code reused in many applications}

  s.rubyforge_project = 'neuron'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '~> 3.0'
  s.add_development_dependency 'rake'
end
