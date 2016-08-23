# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','dopc','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'dopc'
  s.version = Dopc::VERSION
  s.author = 'Anselm Strauss'
  s.email = 'Anselm.Strauss@swisscom.com'
  s.homepage = 'http://www.swisscom.ch'
  s.platform = Gem::Platform::RUBY
  s.summary = 'CLI client for DOPc'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','dopc.rdoc']
  s.rdoc_options << '--title' << 'dopc' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'dopc'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('test-unit')
  s.add_runtime_dependency('gli','~> 2')
  s.add_runtime_dependency('rest-client','~> 2')
  s.add_runtime_dependency('json','~> 1')
end
