# Changelog  VERSION = '0.3.3'

* feature
  * Add max of workers can you be ask

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/11)

# Changelog  VERSION = '0.3.2'

* bug fix
  * missing one return to avoid connection on forbidden mode.

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/10)

# Changelog  VERSION = '0.3.1'

* bug fix
  * we never can be scale down worker on safe mode

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/9)

# Changelog  VERSION = '0.3.0'
* feature
  * Add another mode for thresholds

* bug fix
  * fix size of working job count at ZERO instead of one

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/8)

# Changelog  VERSION = '0.2.1'

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/7)

# Changelog  VERSION = '0.2.0'

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/6)

# Changelog  VERSION = '0.1.9'

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/5)

# Changelog  VERSION = '0.1.8'

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/4)

# Changelog  VERSION = '0.1.7'

[Fullcahnges](https://github.com/joel/heroku-resque-workers-scaler/pull/4)

# Changelog  VERSION = '0.1.6'

* Changes name from heroku-resque-auto-scale to heroku-resque-workers-scaler

# Changelog  VERSION = '0.1.5'

* Add safe mode for Heroku

# Changelog  VERSION = '0.1.4'

* Add protection execution for determinate environments, defaults 'production'
* Add possibilité of override config on your project

# Changelog  VERSION = '0.1.3'

## Principals changes :

* Switch from Jeweler Gem generator to simple Bundler gem generator
* Switch to Rspec from TestUnit
* Switch to HerokuAPI Gem instead of Heroku Client Gem
* Configuration into yaml file (optionnal)

### Requirements :

You need to defined two vars for your heroku app :

Go to your https://api.heroku.com/account for retreive your API Key

heroku config:add HEROKU_API_KEY=your_api_key -a your_app_name
heroku config:add HEROKU_APP_NAME=your_app_name -a your_app_name

### Configuration

You can changes thresholds into scaler_config.yml (It's totally optional)

### Test

You can test with this command line :

  HEROKU_API_KEY=your_api_key HEROKU_APP_NAME=your_app_name *** bundle exec *** rake spec
