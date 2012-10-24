require 'test/unit'
require 'logbundler'

class Logbundler::MakeBundleTest < Test::Unit::TestCase

  # example config Ruby hash
  CFG = {
    'system' => [ # System Log Group
      {
        'shell' => 'ls ~',
        'timeout' => '5s',
        'stdout' => 'home/ls.out',
      },
      {
        'shell' => 'env > $TMPDIR/env.out',
      },
      {
        'shell' => 'sleep 10000',
        'timeout' => '2s',
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

  def setup
    @json_str = JSON.dump(CFG)
  end

  def test_make_bundle
    logbundle = Logbundler.new
    logbundle.read_config(@json_str)
    logbundle.execute
  end

end
