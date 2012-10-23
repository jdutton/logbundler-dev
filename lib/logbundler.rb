require 'logbundler/config'
require 'logbundler/execute'

class Logbundler
  attr_reader :config
  
  def initialize
    @config = Logbundler::Config.new
    @execute = Logbundler::Execute.new
  end

  def read_config(hash_or_jsonstr)
    @config.read(hash_or_jsonstr)
  end

  def self.log(str)
    $stderr << Time.now.strftime("%Y-%m-%d %H:%M:%S  ") << str << "\n"
  end

  def execute
    @execute.execute(@config)
  end
end
