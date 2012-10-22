require 'logbundler/config'

class Logbundler
  attr_reader :config
  
  def initialize
    @config = Logbundler::Config.new
  end
end
