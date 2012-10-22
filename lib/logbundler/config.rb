require 'yaml'

class Logbundler

  class Config

    def initialize
      @config = Hash.new
    end

    def get(category)
      @config[category]
    end

    def read(file)
      read_yaml(File.read(file))
    end
    
    def read_yaml(str)
      cfg = YAML.load(str)
      add(cfg)
    end

    # Config is a Hash of Array's of config objects
    def add(cfg)
      cfg.each_key do |key|
        @config[key] ||= []
        cfg[key].each { |list_entry| @config[key] << list_entry }
      end
    end

  end  

end
