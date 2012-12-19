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
