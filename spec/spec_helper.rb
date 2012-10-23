$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'webmock/rspec'
require 'heroku-resque-auto-scale'
require 'json'
require 'resque'
require 'rails'

RSpec.configure do |config|
  config.mock_with :rspec
end

# RSpec.configuration.after(:each) do
# end

# RSpec.configuration.before(:each) do
# end