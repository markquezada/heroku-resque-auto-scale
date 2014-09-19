require 'spec_helper'

describe HerokuResqueAutoScale::Scaler do

  context 'when authorised' do
    before { allow(HerokuResqueAutoScale::Scaler).to receive(:authorized?) { true }}

    context 'with safe mode disabled' do
      before { allow(HerokuResqueAutoScale::Scaler).to receive(:safe_mode?) { false }}

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
          allow_any_instance_of(PlatformAPI::Client).to receive_message_chain(:formation, :info) { response_hash }
        end

        it { expect(HerokuResqueAutoScale::Scaler.workers).to eql(42) }
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
          allow_any_instance_of(PlatformAPI::Client).to receive_message_chain(:formation, :update) { response_hash }
        end

        it { expect(HerokuResqueAutoScale::Scaler.send(:workers=, 69)).to be_truthy }
      end

      describe 'ask for job and working count' do
        before { allow(Resque).to receive(:info) {{ pending: '16', working: '61' }} }

        it { expect(HerokuResqueAutoScale::Scaler.job_count).to eql 16 }
        it { expect(HerokuResqueAutoScale::Scaler.working_job_count).to eql 61 }
      end
    end

    context 'with safe mode enabled' do
      before { allow(HerokuResqueAutoScale::Scaler).to receive(:safe_mode?) { true }}

      context 'when about to scale down' do
        before { allow(HerokuResqueAutoScale::Scaler).to receive(:scale_down?) { true }}

        context 'when there are some jobs left to process' do
          before { allow(HerokuResqueAutoScale::Scaler).to receive(:all_jobs_have_been_processed?) { false }}

          # it 'does not trigger the API call' do
          #   allow_any_instance_of(PlatformAPI::Client).to_not receive(:formation)
          #   HerokuResqueAutoScale::Scaler.send(:workers=, '69')
          # end
        end

        context 'when there are no jobs left to process' do
          before { allow(HerokuResqueAutoScale::Scaler).to receive(:all_jobs_have_been_processed?) { true }}

          describe 'should trigger action' do
            it 'does not trigger the API call' do
              mock_client = double(PlatformAPI::Client).as_null_object
              allow_any_instance_of(PlatformAPI::Client).to receive(:formation) { mock_client }
              HerokuResqueAutoScale::Scaler.send(:workers=, '69')
            end
          end
        end
      end

    end
  end

end
