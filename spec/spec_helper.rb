require 'heroku-resque-workers-scaler'
require 'bundler/setup'

require 'resque'
require 'coveralls'

begin
  require 'pry'
rescue LoadError
end

Coveralls.wear!

RSpec.configure do |config|
  config.mock_with :rspec
end

# RSpec.configuration.after(:each) do
# end

# RSpec.configuration.before(:each) do
# end
