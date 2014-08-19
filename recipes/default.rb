#
# Cookbook Name:: encrypted_attributes
# Recipe:: default
#
# Copyright 2014, Onddo Labs, Sl.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node['encrypted_attributes']['mirror_url'].kind_of?(String) and node['encrypted_attributes']['version'].kind_of?(String)
  # install from a mirror
  encrypted_attribute_file = "chef-encrypted-attributes-#{node['encrypted_attributes']['version']}.gem"
  remote_file ::File.join(Chef::Config[:file_cache_path], encrypted_attribute_file) do
    source "#{node['encrypted_attributes']['mirror_url']}/#{encrypted_attribute_file}"
  end.run_action(:create)
  gem_package 'chef-encrypted-attributes' do
    source ::File.join(Chef::Config[:file_cache_path], encrypted_attribute_file)
  end.run_action(:install)
else
  # install from rubygems
  prerelease = node['encrypted_attributes']['version'].kind_of?(String) && node['encrypted_attributes']['version'].match(/^[0-9.]+$/) != true
  chef_gem 'chef-encrypted-attributes' do
    if node['encrypted_attributes']['version'].kind_of?(String)
      version node['encrypted_attributes']['version']
    end
    options(:prerelease => true) if prerelease
  end
end

require 'chef-encrypted-attributes'
