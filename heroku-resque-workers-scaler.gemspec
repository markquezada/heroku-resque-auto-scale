# -*- encoding: utf-8 -*-
require File.expand_path('../lib/heroku-resque-workers-scaler/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Mark Quezada', 'Joel AZEMAR']
  gem.email         = ['mark@mirthlab.com', 'joel.azemar@gmail.com']
  gem.description   = %q{Auto scale your resque workers on Heroku.}
  gem.summary       = %q{Simple helper for Rails App configuration}
  gem.homepage      = 'http://github.com/mirthlab/heroku-resque-workers-scaler'
  # gem.homepage    = 'https://github.com/joel/heroku-resque-workers-scaler'
  gem.licenses      = [ 'MIT' ]
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = 'heroku-resque-workers-scaler'
  gem.require_paths = ['lib']
  gem.version       = HerokuResqueAutoScale::VERSION

  gem.add_runtime_dependency 'resque'
  gem.add_runtime_dependency 'platform-api'
  
  gem.add_development_dependency 'rails'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'psych'
end