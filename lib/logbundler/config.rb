require 'json'

class Logbundler

  class Config
    include Enumerable

    def initialize
      @config = Hash.new
    end

    def [](category)
      @config[category]
    end

    def each()
      @config.each_pair do |group, entity_list|
        next unless entity_list.respond_to?(:each)
        entity_list.each do |entity|
          yield entity
        end
      end
    end

    def read(hash_or_jsonstr)
      if hash_or_jsonstr.is_a?(String)
        read_json(hash_or_jsonstr)
      else
        add(hash_or_jsonstr)
      end
    end

    def read_file(file)
      read_json(File.read(file))
    end
    
    def read_json(str)
      cfg = JSON.load(str)
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
