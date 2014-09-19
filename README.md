[![Code Climate](https://codeclimate.com/github/joel/heroku-resque-workers-scaler.png)](https://codeclimate.com/github/joel/heroku-resque-workers-scaler)

[![Dependency Status](https://gemnasium.com/joel/heroku-resque-workers-scaler.png)](https://gemnasium.com/joel/heroku-resque-workers-scaler)

[![Build Status](https://travis-ci.org/joel/heroku-resque-workers-scaler.png?branch=master)](https://travis-ci.org/joel/heroku-resque-workers-scaler) (Travis CI)

[![Coverage Status](https://coveralls.io/repos/joel/heroku-resque-workers-scaler/badge.png)](https://coveralls.io/r/joel/heroku-resque-workers-scaler)

[![Gem Version](https://badge.fury.io/rb/heroku-resque-workers-scaler.svg)](http://badge.fury.io/rb/heroku-resque-workers-scaler)

# heroku-resque-workers-scaler

Auto scale your resque workers on Heroku. Original code by darkhelmet:

* http://blog.darkhax.com/2010/07/30/auto-scale-your-resque-workers-on-heroku
* https://gist.github.com/501160

Modify by joel => https://github.com/joel

On fork => https://github.com/joel/heroku-resque-workers-scaler

### Principals changes :

* I've switched Jeweler Gem generator to simpel Bundler gem generator
* I've switched to Rspec from TestUnit
* I've switched to HerokuAPI Gem instead of Heroku Client Gem
* Add safe mode for heroku
* See CHANGELOG

### Configuration :

You need to defined two vars for your heroku :

`Go to your https://api.heroku.com/account`

```
heroku config:add HEROKU_API_KEY=your_api_key -a your_app_name
heroku config:add HEROKU_APP_NAME=your_app_name -a your_app_name
heroku config:add SAFE_MODE=true -a your_app_name
```

## Run localy

You can test when executed this :

```
export HEROKU_API_KEY=your_api_key
export HEROKU_APP_NAME=your_app_name
export SAFE_MODE=true
export ENVIRONMENT=development
```
open `irb`

```
irb -r heroku-resque-workers-scaler -I ./lib
```
play with commands
```
>> HerokuResqueAutoScale::Scaler.workers
=> 0
>> HerokuResqueAutoScale::Scaler.workers=1
=> 1
>> HerokuResqueAutoScale::Scaler.workers=0
=> 0
```

You can change the thresholds, environments of execution and the name of your worker process in your project on config/scaler_config.yml

Exmple YAML file contents:

    mode: :thresholds # :fit, :half, :third
    thresholds:
    - :workers: 1
      :job_count: 1
    - :workers: 2
      :job_count: 15
    environments:
      - production
    worker_name: resque

if you use `mode: :fit` the number of job is exactly the same of available worker, `:half` the number of worker is 1/2 of number of job in queue, and for `third` 1/3

I just bundled it into a gem for easy inclusion into other projects.

#### Usage

Once the gem is installed, simply extend your job class as follows:
```
	class ScalingJob
		extend HerokuResqueAutoScale

		def self.perform
			# Do something long running
		end
	end
```
#### Active safe mode

When you ask heroku for scale down workers, heroku send SIGTERM and wait 4 secondes then send SIGKILL, but the worker catch signals can be currently work :( It's bad but Heroku not provide API for manage this case today, you can look arround this [official article](https://devcenter.heroku.com/articles/queuing-ruby-resque#job-termination) but in this gem if you defined var ENV['SAFE_MODE'] :
```
	heroku config:add SAFE_MODE=true -a your_app_name
```
## Contributing to heroku-resque-workers-scaler

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2010 Mark Quezada. See LICENSE.txt for
further details.
