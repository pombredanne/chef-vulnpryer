name             'vulnpryer'
maintainer       'David F. Severski'
maintainer_email 'davidski@deadheaven.com'
license          'MIT'
description      'Installs and configures vulnpryer'
long_description 'Installs and configures vulnpryer'
version          '0.1.2'

supports         'ubuntu'
supports         'amazon'
supports         'redhat'
supports         'centos'

depends 'python', ">= 1.4.6"
depends 'aws', '>= 2.4.0'
depends 'chef-sugar', '>= 2.0.0'
depends 'cron', '>= 1.4.0'