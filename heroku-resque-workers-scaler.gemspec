require_relative 'lib/heroku-resque-workers-scaler/version'

Gem::Specification.new do |spec|
  spec.name        = 'heroku-resque-workers-scaler'
  spec.version     = HerokuResqueAutoScale::VERSION
  spec.date        = '2012-10-22'
  spec.summary     = %q{Simple helper for Rails App configuration}
  spec.description = %q{Auto scale your resque workers on Heroku.}
  spec.authors     = ['Mark Quezada', 'Joel AZEMAR']
  spec.email       = ['mark@mirthlab.com', 'joel.azemar@gmail.com']

  spec.homepage    = 'https://github.com/joel/heroku-resque-workers-scaler'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'resque', '~> 1.25.2'
  spec.add_dependency 'platform-api', '~> 0.2.0'

  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'webmock', '~> 1.18.0'
  spec.add_development_dependency 'rake', '~> 10.3.2'
  spec.add_development_dependency 'psych', '~> 2.0.6'

  # spec.required_ruby_version = '~> 2.1'
end
