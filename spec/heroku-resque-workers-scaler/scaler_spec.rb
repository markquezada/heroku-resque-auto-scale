require 'spec_helper'

describe HerokuResqueAutoScale::Scaler do

  context 'when authorised' do

    before { HerokuResqueAutoScale::Scaler.stub(:authorized?).and_return(true) }

    context 'with safe mode disabled' do

      before { HerokuResqueAutoScale::Scaler.stub(:safe_mode?).and_return(false) }

      describe 'get number of workers' do
        before do
          response_hash = {
              'command' => 'bundle exec rails server -p $PORT',
              'created_at' => '2012-01-01T12:00:00Z',
              'id' => '01234567-89ab-cdef-0123-456789abcdef',
              'quantity' => 42,
              'size' => '1X',
              'type' => 'web',
              'updated_at' => '2012-01-01T12:00:00Z'
          }
          PlatformAPI::Client.any_instance.stub_chain(:formation, :info).and_return(response_hash)
        end
  
        it { HerokuResqueAutoScale::Scaler.workers.should eql 42 }
      end
  
      describe 'set number of workers' do
        before do
          response_hash = {
              'command' => 'bundle exec rails server -p $PORT',
              'created_at' => '2012-01-01T12:00:00Z',
              'id' => '01234567-89ab-cdef-0123-456789abcdef',
              'quantity' => 69,
              'size' => '1X',
              'type' => 'web',
              'updated_at' => '2012-01-01T12:00:00Z'
          }

          PlatformAPI::Client.any_instance.stub_chain(:formation, :update).and_return(response_hash)
        end
    
        it { HerokuResqueAutoScale::Scaler.send(:workers=, 69).should be_true }
      end
  
      describe 'ask for job and working count' do
        before { Resque.stub(info: { pending: '16', working: '61' }) }
    
        it { HerokuResqueAutoScale::Scaler.job_count.should eql 16 }
        it { HerokuResqueAutoScale::Scaler.working_job_count.should eql 61 }
      end
    end
    
    context 'with safe mode enabled' do
      before { HerokuResqueAutoScale::Scaler.stub safe_mode?: true }

      context 'when about to scale down' do
        before { HerokuResqueAutoScale::Scaler.stub setting_this_number_of_workers_will_scale_down?: true }

        context 'when there are some jobs left to process' do
          before { HerokuResqueAutoScale::Scaler.stub all_jobs_hve_been_processed?: false }

          it 'does not trigger the API call' do
            PlatformAPI::Client.any_instance.should_not_receive(:formation)
            HerokuResqueAutoScale::Scaler.send(:workers=, '69')
          end
        end

        context 'when there are no jobs left to process' do
          before { HerokuResqueAutoScale::Scaler.stub all_jobs_hve_been_processed?: true }

          describe 'should trigger action' do
            it 'does not trigger the API call' do
              mock_client = double(PlatformAPI::Client).as_null_object
              PlatformAPI::Client.any_instance.should_receive(:formation).and_return(mock_client)
              HerokuResqueAutoScale::Scaler.send(:workers=, '69')
            end
          end
        end
      end
      
    end
  end
  
end