name             'vulnpryer'
maintainer       'David F. Severski'
maintainer_email 'davidski@deadheaven.com'
license          'MIT'
description      'Installs and configures vulnpryer'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/davidski/chef-vulnpryer' if respond_to?(:source_url)
issues_url       'https://github.com/davidski/chef-vulnpryer/issues' if respond_to?(:issues_url)
version          '0.2.0'
chef_version     '>= 12.1'

supports         'ubuntu'
supports         'amazon'
supports         'redhat'
supports         'centos'
supports         'debian'

depends 'poise-python', '>= 1.5.1'
depends 'aws', '>= 2.4.0'
depends 'chef-sugar', '>= 3.1.1'
depends 'cron', '>= 1.4.0'
