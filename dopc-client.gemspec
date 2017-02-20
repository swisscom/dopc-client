# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','dopc-client','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'dopc-client'
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
  s.extra_rdoc_files = ['README.rdoc','dopc-client.rdoc']
  s.rdoc_options << '--title' << 'dopc-client' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'dopc-client'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('test-unit')
  s.add_development_dependency('byebug')
  s.add_development_dependency('rspec')
  s.add_development_dependency('rspec-command')
  s.add_development_dependency('pry')
  s.add_development_dependency('pry-byebug')
  s.add_runtime_dependency('gli','~> 2')
  s.add_runtime_dependency('rest-client','~> 2')
  s.add_runtime_dependency('json','~> 1')
  s.add_runtime_dependency('dop_common','~> 0.11', '>= 0.11.0')
  s.add_runtime_dependency('table_print','~> 1')
end
