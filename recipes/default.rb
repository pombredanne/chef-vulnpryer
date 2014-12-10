#
# Cookbook Name:: vulnpryer
# Recipe:: default
#
# Copyright (C) 2014 David F. Severski
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

vulndb_user = node['vulnpryer']['user']

user vulndb_user do
  system true
  uid node['vulnpryer']['uid']
  #gid node['vulnpryer']['gid']
  #home node['vulnpryer']['homedir']
end

directory node['vulnpryer']['homedir'] do
  owner vulndb_user
  group vulndb_user
end

git node['vulnpryer']['homedir'] do
  repository node['vulnpryer']['repository']
  revision node['vulnpryer']['repository_branch']
  action :sync
  user vulndb_user
  group vulndb_user
end

if (!node['vulnpryer']['config']['s3']['aws_access_key_id'].nil? and 
  !node['vulnpryer']['config']['s3']['aws_secret_access_key'].nil?)
  directory "#{node['vulnpryer']['homedir']}/.aws" do
    owner vulndb_user
    group vulndb_user
    mode "0750"
  end
  
  template "#{node['vulnpryer']['homedir']}/.aws/credentials" do
    source "credentials.erb"
    owner vulndb_user
    group vulndb_user
    mode "0640"
  end
end

directory node['vulnpryer']['config']['vulndb']['json_dir'] do
  owner vulndb_user
  group vulndb_user
  mode "0775"
end

include_recipe "python::default"

#platform specific bits required for pip builds to run
if platform_family?("debian")
  %w(libxml2-dev libxslt1-dev python-dev zlib1g-dev).each do |pkg|
    package pkg
  end
elsif platform_family?("rhel")
  %w(libxslt-devel).each do |pkg|
    package pkg
  end
end

virtualenv = "#{node['vulnpryer']['homedir']}/vulnpryer_ve"

python_virtualenv virtualenv do
  interpreter "python2.7"
  owner vulndb_user
  group vulndb_user
  action :create
end

%w(boto restkit simplejson oauth2 lxml pymongo filechunkio).each do |pipmod|
  python_pip pipmod
end

#path of least resistence to get pandas installed
if platform_family?("debian")
  package "python-pandas"
elsif platform_family?("rhel")
  python_pip "pandas"
end

#deprecated in favor of the forthcoming git publish
#%w(vulnpryer.py vulndb.py trl.py mongo_loader.py).each do |script|
#  cookbook_file script do
#    path "/opt/vulndb/#{script}"
#    owner vulndb_user
#    group vulndb_user
#    mode "0755"
#  end
#end

my_vars = node['vulnpryer']['config']

template "#{node['vulnpryer']['homedir']}/vulnpryer.conf" do
  source "vulnpryer.conf.erb"
  owner vulndb_user
  group vulndb_user
  mode "0664"
end