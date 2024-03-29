require 'test/unit'
require 'logbundler'

class Logbundler::ConfigTest < Test::Unit::TestCase

  # example config Ruby hash
  CFG = {
    'system' => [ # System Log Group
      {
        'shell' => 'rpm -qa',
        'timeout' => '10s',
        'stdout' => 'rpms/rpm-qa.stdout',
      },
      {
        'shell' => 'dmidecode',
        'timeout' => '5s',
        'stdout' => 'sys/dmidecode.out',
      },
    ],

    'tomcat' => [ # Tomcat Application Log Group
      {
        'files' => '/opt/comcat/logs/catelina.log*',
        'filetype' => 'catelina-access',
      },
      {
        'shell' => 'service tomcat status',
        'timeout' => '3s',
        'stdout' => 'tomcat/service.status',
      },
    ],
  }

  def test_read_json
    json = JSON.dump(CFG)
    cfg = Logbundler::Config.new
    cfg.read_json(json)
    assert_equal 'sys/dmidecode.out', cfg['system'][1]['stdout']
  end
  
end
