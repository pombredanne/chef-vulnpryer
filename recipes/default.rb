#
# Cookbook Name:: vulnpryer
# Recipe:: default
#
# Copyright (C) 2016 David F. Severski
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe 'chef-sugar::default'

vulnpryer_user = node['vulnpryer']['user']

# take a user specified python version, else default to the highest known working
# python version for the platform
python_version = if node['vulnpryer']['python_version']
                   node['vulnpryer']['python_version']
                 elsif platform?('amazon')
                   '3.5'
                 elsif platform?('ubuntu') && platform_version.satisfies?('>=16')
                   '3.5'
                 elsif platform?('ubuntu') || platform?('debian')
                   '3.4'
                 else
                   '2.7'
                 end

# Set default umask to fix AWS OpsWorks issue
# ref: https://forums.aws.amazon.com/thread.jspa?threadID=221317&tstart=0
File.umask(0o0002)

user vulnpryer_user do
  system true
  uid node['vulnpryer']['uid'] if node['vulnpryer']['uid']
  # gid node['vulnpryer']['gid']
  home node['vulnpryer']['homedir']
end

directory node['vulnpryer']['homedir'] do
  owner vulnpryer_user
  group vulnpryer_user
end

if !node['vulnpryer']['config']['s3']['aws_access_key_id'].nil? &&
   !node['vulnpryer']['config']['s3']['aws_secret_access_key'].nil?
  directory "#{node['vulnpryer']['homedir']}/.aws" do
    owner vulnpryer_user
    group vulnpryer_user
    mode '0750'
  end

  template "#{node['vulnpryer']['homedir']}/.aws/credentials" do
    source 'credentials.erb'
    owner vulnpryer_user
    group vulnpryer_user
    mode '0640'
  end
end

directory node['vulnpryer']['config']['vulndb']['json_dir'] do
  owner vulnpryer_user
  group vulnpryer_user
  mode '0775'
  recursive true
end

python_runtime 'vulnpryer' do
  version python_version
end

# platform specific bits required for pip builds to run
if platform_family?('debian')
  %w(libxml2-dev libxslt1-dev python-dev zlib1g-dev).each do |pkg|
    package pkg
  end
elsif platform_family?('rhel')
  %w(libxslt-devel).each do |pkg|
    package pkg
  end
end

# create a venv for all our python depdencies and installs
virtualenv = "#{node['vulnpryer']['homedir']}/vulnpryer_ve"
python_virtualenv virtualenv do
  user vulnpryer_user unless platform_family?('windows')
  group vulnpryer_user unless platform_family?('windows')
  system_site_packages true
  action :create
end

# main install of vulnpryer package
python_package 'VulnPryer' do
  package_name 'VulnPryer'
  virtualenv virtualenv
  install_options node['vulnpryer']['pip_install_options'] if node['vulnpryer']['pip_install_options']
  list_options node['vulnpryer']['pip_list_options'] if node['vulnpryer']['pip_list_options']
  options node['vulnpryer']['pip_options'] if node['vulnpryer']['pip_options']
  user vulnpryer_user unless platform_family?('windows')
  group vulnpryer_user unless platform_family?('windows')
end

template "#{node['vulnpryer']['homedir']}/vulnpryer.conf" do
  source 'vulnpryer.conf.erb'
  owner vulnpryer_user
  group vulnpryer_user
  mode '0664'
end
