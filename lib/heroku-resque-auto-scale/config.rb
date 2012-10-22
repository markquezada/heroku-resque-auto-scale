module HerokuResqueAutoScale
  module Config
    extend self
    
    def thresholds
      @thresholds ||= begin
        if File.exists? 'scaler_config.yml'
          YAML.load_file('scaler_config.yml')['thresholds']
        else
          [{workers:1,job_count:1},{workers:2,job_count:15},{workers:3,job_count:25},{workers:4,job_count:40},{workers:5,job_count:60}]
        end
      end
    end
  end
end
  