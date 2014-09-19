require 'platform-api'
require 'resque'

module HerokuResqueAutoScale
  module Scaler

    class << self
      @@heroku = PlatformAPI.connect(ENV['HEROKU_API_KEY'])

      def workers
        return -1 unless authorized?
        result = @@heroku.formation.info(app_name, worker_name)
        result['quantity']
      end

      def workers=(quantity)
        return unless authorized?

        quantity = quantity.to_i

        if safe_mode? and setting_this_number_of_workers_will_scale_down? quantity
          return unless all_jobs_have_been_processed?
        end
        result = @@heroku.formation.update(app_name, worker_name, { quantity: quantity })
        result['quantity'] == quantity
      end

      def job_count
        Resque.info[:pending].to_i
      end

      def working_job_count
        Resque.info[:working].to_i
      end

      protected

      def app_name
        ENV['HEROKU_APP_NAME']
      end

      def setting_this_number_of_workers_will_scale_down? quantity
        quantity < workers
      end

      def safe_mode?
        ENV['SAFE_MODE'] and ENV['SAFE_MODE'] == 'true'
      end

      def all_jobs_have_been_processed?
        job_count + working_job_count == 0
      end

      private

      def authorized?
        HerokuResqueAutoScale::Config.environments.include? _environment
      end

      def _environment
        if defined?(Rails)
          Rails.env.to_s
        else
          ENV['ENVIRONMENT'] || 'test'
        end
      end

      def worker_name
        HerokuResqueAutoScale::Config.worker_name
      end

    end
  end

  def after_perform_scale_down(*args)
    scale_down
  end

  def on_failure_scale_down(exception, *args)
    scale_down
  end

  def after_enqueue_scale_up(*args)
    HerokuResqueAutoScale::Config.thresholds.reverse_each do |scale_info|
      # Run backwards so it gets set to the highest value first
      # Otherwise if there were 70 jobs, it would get set to 1, then 2, then 3, etc

      # If we have a job count greater than or equal to the job limit for this scale info
      if Scaler.job_count >= scale_info[:job_count]
        # Set the number of workers unless they are already set to a level we want. Don't scale down here!
        if Scaler.workers <= scale_info[:workers]
          Scaler.workers = scale_info[:workers]
        end
        break # We've set or ensured that the worker count is high enough
      end
    end
  end

  private

  def scale_down
    # Nothing fancy, just shut everything down if we have no pending jobs
    # and one working job (which is this job)
    Scaler.workers = 0 if Scaler.job_count.zero? && Scaler.working_job_count == 1
  end
end
