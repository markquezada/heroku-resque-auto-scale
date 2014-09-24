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

        if safe_mode?
          if scale_down? quantity
            return false unless all_jobs_have_been_processed?
          else
            return false if too_many_workers_asked?(quantity)
          end
        end

        result = @@heroku.formation.update(app_name, worker_name, { quantity: quantity })
        result['quantity'] == quantity
      end

      def shut_down_workers!
        return unless authorized?
        @@heroku.formation.update(app_name, worker_name, { quantity: 0 })
        nil
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

      def scale_down? quantity
        quantity < workers
      end

      def too_many_workers_asked? quantity
        quantity >= Config.threshold
      end

      def safe_mode?
        ENV['SAFE_MODE'] and ENV['SAFE_MODE'] == 'true'
      end

      def all_jobs_have_been_processed?
        job_count + working_job_count == 0
      end

      private

      def authorized?
        Config.environments.include? _environment
      end

      def _environment
        if defined?(Rails)
          Rails.env.to_s
        else
          ENV['ENVIRONMENT'] || 'test'
        end
      end

      def worker_name
        Config.worker_name
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
    case Config.mode
    when :thresholds
      Config.thresholds.reverse_each do |scale_info|
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
    when :fit
      Scaler.workers = Scaler.job_count
    when :half
      Scaler.workers = (Scaler.job_count/2)
    when :third
      Scaler.workers = (Scaler.job_count/3)
    end
  end

  private

  def scale_down
    # Nothing fancy, just shut everything down if we have no pending jobs
    # and one working job (which is this job)
    Scaler.shut_down_workers! if Scaler.job_count.zero? && Scaler.working_job_count <= 1
  end
end
