#
# Cookbook Name:: ud-cactiserver
# Recipe:: default
#
# Copyright 2014, Urbandecoder Labs LLC
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

include_recipe 'ud-httpserver'

httpd_module 'php5' do
  package_name 'php' # XXX work around silly bugs
  action :create
end

httpd_config 'php_config' do
  config_name 'php'
  source 'mod_php.conf.erb'
  action :create
end

package 'cacti' do
  action :install
end

httpd_config 'cacti_config' do
  config_name 'cacti'
  source 'cacti.conf.erb'
  action :create
end
