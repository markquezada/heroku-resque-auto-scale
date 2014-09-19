require 'spec_helper'

describe HerokuResqueAutoScale::Config do

  before(:each) do
    HerokuResqueAutoScale.send(:remove_const, 'Config')
    load 'lib/heroku-resque-workers-scaler/config.rb'
  end

  context 'using the supplied config file' do
    it { expect(HerokuResqueAutoScale::Config.thresholds).to be_instance_of Array }
    it { expect(HerokuResqueAutoScale::Config.environments).to eql(['production','staging', 'development']) }
    it { expect(HerokuResqueAutoScale::Config.worker_name).to eql 'worker' }
  end
end
