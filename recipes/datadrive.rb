#
# Cookbook Name:: vulnpryer
# Recipe:: datadrive.rb
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

include_recipe 'chef-sugar::default'

# Adapted from https://gist.github.com/clarkdave/5477434
# The datadrive recipe creates a /data directory and, if on EC2, 
# will mount an EBS volume here

vulndb_user = node['vulnpryer']['user']

directory '/data' do
  mode '0755'
  owner vulndb_user
  group vulndb_user
end
 
if ec2?

  include_recipe 'aws::default'
 
  if node['vulnpryer']['ebs']['raid']
 
    aws_ebs_raid 'data_volume_raid' do
      mount_point '/data'
      disk_count 2
      disk_size node['vulnpryer']['ebs']['size']
      level 10
      filesystem 'ext4'
      action :auto_attach
    end
 
  else
 
    # get a device id to use
    if rhel?
      devices = Dir.glob('/dev/sd?')
      devices = ['/dev/sdh'] if devices.empty?
    elsif debian?
      devices = Dir.glob('/dev/xvd?')
      devices = ['/dev/xvdf'] if devices.empty?
    end
    devid = devices.sort.last[-1,1].succ
 
    # save the device used for data_volume on this node -- this volume will now always
    # be attached to this device
    if rhel?
      node.set_unless['vulnpryer']['ebs']['device_id'] = "/dev/sd#{devid}"
    elsif debian?
      node.set_unless['vulnpryer']['ebs']['device_id'] = "/dev/xvd#{devid}"
    end
 
    device_id = node['vulnpryer']['ebs']['device_id']
 
    # no raid, so just mount and format a single volume
    aws_ebs_volume 'data_volume' do
      size node['vulnpryer']['ebs']['size']
      device node['vulnpryer']['ebs']['device_id']
      volume_id node['vulnpryer']['ebs']['volume_id']
      action [:attach]
    end
 
    # wait for the drive to attach, before making a filesystem
    ruby_block "sleeping_data_volume" do
      block do
        timeout = 0
        until File.blockdev?(device_id) || timeout == 1000
          Chef::Log.debug("device #{device_id} not ready - sleeping 10s")
          timeout += 10
          sleep 10
        end
      end
    end
 
    # create a filesystem
    execute 'mkfs' do
      command "mkfs -t ext4 #{device_id}"
      not_if "e2label #{device_id}"
    end

    mount '/data' do
      device device_id
      fstype 'ext4'
      options 'noatime'
      action [:enable, :mount]
    end
  end
end