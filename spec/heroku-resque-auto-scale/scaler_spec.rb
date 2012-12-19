require 'spec_helper'

# HEROKU_API_KEY=your_api_key HEROKU_APP_NAME=your_app_name bundle exec rake spec
describe HerokuResqueAutoScale::Scaler do

  context 'authorised' do
    before { HerokuResqueAutoScale::Scaler.stub authorised?: true }
    context 'unsafe mode' do
      before { HerokuResqueAutoScale::Scaler.stub safe_mode?: false }
  
      context 'get number of workers' do
        before do
          stub_request(:get, "https://api.heroku.com/apps/your_app_name").
            with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip', 'Authorization'=>'Basic OnlvdXJfYXBpX2tleQ==', \
              'Host'=>'api.heroku.com:443', 'User-Agent'=>'heroku-rb/0.3.5', 'X-Ruby-Platform'=>'x86_64-darwin12.2.0', 'X-Ruby-Version'=>'1.9.3'}).
              to_return(:status => 200, :body => JSON.generate({ workers: '42' }), :headers => {})
        end
  
        it { HerokuResqueAutoScale::Scaler.workers.should eql 42 }
      end
  
      context 'set number of workers' do
        before do
          stub_request(:post, "https://api.heroku.com/apps/your_app_name/ps/scale?qty=69&type=worker").
            with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip', 'Authorization'=>'Basic OnlvdXJfYXBpX2tleQ==', \
              'Host'=>'api.heroku.com:443', 'User-Agent'=>'heroku-rb/0.3.5', 'X-Ruby-Platform'=>'x86_64-darwin12.2.0', 'X-Ruby-Version'=>'1.9.3'}).
              to_return(:status => 200, :body => "", :headers => {})
        end
    
        it { HerokuResqueAutoScale::Scaler.send(:workers=, '69') }
      end
  
      context 'ask for job and working count' do
        before { Resque.stub(info: { pending: '16', working: '61' }) }
    
        it { HerokuResqueAutoScale::Scaler.job_count.should eql 16 }
        it { HerokuResqueAutoScale::Scaler.working_job_count.should eql 61 }
      end
    end
    
    context 'on safe mode' do
      before { HerokuResqueAutoScale::Scaler.stub safe_mode?: true }
      
      context 'try unsafe action' do
        before { HerokuResqueAutoScale::Scaler.stub safer?: false, down?: true }
        
        describe 'should not trigger action' do
          
          it { HerokuResqueAutoScale::Scaler.send(:workers=, '69').should be_nil } # Webmock do nothing here
        end
      end
      
      context 'try safe action' do
        before { HerokuResqueAutoScale::Scaler.stub safer?: true, down?: true }
        
        describe 'should not trigger action' do
          before do
            stub_request(:post, "https://api.heroku.com/apps/your_app_name/ps/scale?qty=69&type=worker").
              with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip', 'Authorization'=>'Basic OnlvdXJfYXBpX2tleQ==', \
                'Host'=>'api.heroku.com:443', 'User-Agent'=>'heroku-rb/0.3.5', 'X-Ruby-Platform'=>'x86_64-darwin12.2.0', 'X-Ruby-Version'=>'1.9.3'}).
                to_return(:status => 200, :body => "", :headers => {})
          end
          
          it { HerokuResqueAutoScale::Scaler.send(:workers=, '69') }
        end
      end
      
    end
  end
  
end