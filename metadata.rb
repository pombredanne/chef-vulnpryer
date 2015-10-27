name             'vulnpryer'
maintainer       'David F. Severski'
maintainer_email 'davidski@deadheaven.com'
license          'MIT'
description      'Installs and configures vulnpryer'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/SCH-CISM/chef-vulnpryer' if respond_to?(:source_url)
issues_url       'https://github.com/SCH-CISM/chef-vulnpryer/issues' if respond_to?(:issues_url)
version          '0.1.3'

supports         'ubuntu'
supports         'amazon'
supports         'redhat'
supports         'centos'

depends 'python', '>= 1.4.6'
depends 'aws', '>= 2.4.0'
depends 'chef-sugar', '>= 3.1.1'
depends 'cron', '>= 1.4.0'
