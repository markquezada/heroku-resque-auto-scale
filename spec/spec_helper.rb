require 'heroku-resque-workers-scaler'
require 'bundler/setup'

require 'resque'

begin
  require 'pry'
rescue LoadError
end

RSpec.configure do |config|
  config.mock_with :rspec
end

# RSpec.configuration.after(:each) do
# end

# RSpec.configuration.before(:each) do
# end
