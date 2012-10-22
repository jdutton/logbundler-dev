require 'logbundler/config'

class Logbundler
  attr_reader :config
  
  def initialize
    @config = Logbundler::Config.new
  end

  def read_config_from_dir(dir)
    
  end
end
