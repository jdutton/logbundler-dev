require File.expand_path('../lib/logbundler/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'logbundler'
  s.version = Logbundler::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = 'Logbundler creates diagnostic archives for offline debugging and analysis of your server/application'
  s.description = s.summary
  s.author = 'Jeff Dutton'
  s.email = 'jeff.r.dutton@gmail.com'
  s.homepage = 'https://github.com/jdutton/logbundler'

  s.add_dependency 'rubyzip'
  s.add_dependency 'json'
  s.add_dependency 'mixlib-shellout'
  s.add_dependency 'rake'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec-core'

  s.bindir = 'bin'
  s.executables = %w( logbundler )
  s.require_path = 'lib'

  s.files = %w( README.rdoc Rakefile ) + Dir.glob('lib/**/*')
end
