require 'yaml'

module HerokuResqueAutoScale
  module Config
    extend self

    CONFIG_FILE_NAME = 'scaler_config.yml'
    
    def mode
      @mode ||= config['mode']
    end

    def thresholds
      @thresholds ||= config['thresholds']
    end

    def environments
      @environments ||= config['environments']
    end

    def worker_name
      @worker_name ||= config['worker_name']
    end

    private

    def config
      @config ||= YAML.load_file(config_route_path)
    end

    def config_route_path
      if defined?(Rails) && File.exists?(Rails.root.join("config/#{CONFIG_FILE_NAME}").to_s)
        Rails.root.join("config/#{CONFIG_FILE_NAME}").to_s
      else
        File.expand_path("../../../config/#{CONFIG_FILE_NAME}", __FILE__)
      end
    end
  end
end
