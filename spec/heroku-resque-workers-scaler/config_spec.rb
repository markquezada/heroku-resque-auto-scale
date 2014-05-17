require 'spec_helper'

describe HerokuResqueAutoScale::Config do
  it { HerokuResqueAutoScale::Config.thresholds.should be_instance_of Array }
  it { HerokuResqueAutoScale::Config.environments.should eql ['production','staging'] }
  it { HerokuResqueAutoScale::Config.worker_name.should eql 'worker' }

  context 'with missing config values' do
    before :each do
      HerokuResqueAutoScale::Config.stub(:config).and_return({})
    end

    it { HerokuResqueAutoScale::Config.thresholds.should be_instance_of Array }
    it { HerokuResqueAutoScale::Config.environments.should eql ['production'] }
    it { HerokuResqueAutoScale::Config.worker_name.should eql 'worker' }

  end
end
  
  