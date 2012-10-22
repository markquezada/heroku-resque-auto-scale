require 'spec_helper'

describe HerokuResqueAutoScale::Scaler do
  
  before do
    stub_request(:get, "https://api.heroku.com/apps/").
      with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip', 'Authorization'=>'Basic Og==', 'Host'=>'api.heroku.com:443', 'User-Agent'=>'heroku-rb/0.3.5', 'X-Ruby-Platform'=>'x86_64-darwin12.2.0', 'X-Ruby-Version'=>'1.9.3'}).
      to_return(:status => 200, :body => JSON.generate({ workers: '42' }), :headers => {})
  end
  
  it { HerokuResqueAutoScale::Scaler.workers.should eql 42 }
    
end

