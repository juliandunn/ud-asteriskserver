#
# Cookbook Name:: ud-asteriskserver
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

include_recipe 'asterisk'

def data_bag_items(bag_name)
  data_bag(bag_name).map { |id| data_bag_item bag_name, id }
end

iax = data_bag_items(:asterisk_iax)
voicemailboxes = data_bag_items(:asterisk_voicemailboxes)

template "#{node['asterisk']['prefix']['conf']}/asterisk/iax.conf" do
  source 'iax.conf.erb'
  owner node['asterisk']['user']
  group node['asterisk']['group']
  mode '0640'
  action :create
  variables(
    :iax => iax
  )
  notifies :reload, 'service[asterisk]'
end

template "#{node['asterisk']['prefix']['conf']}/asterisk/voicemail.conf" do
  source 'voicemail.conf.erb'
  owner node['asterisk']['user']
  group node['asterisk']['group']
  mode '0640'
  action :create
  variables(
    :voicemailboxes => voicemailboxes
  )
  notifies :reload, 'service[asterisk]'
end

# Symlink a bunch of crap from nonstandard Debian packaging to where it
# really should go
%w{macroform-cold_day.gsm macroform-robot_dity.gsm macroform-the_simplicity.gsm manolo_camp-morning_coffee.gsm reno_project-system.gsm}.each do |moh|
  link "#{node['asterisk']['prefix']['state']}/lib/asterisk/moh/#{moh}" do
    to "/usr/share/asterisk/moh/#{moh}"
  end
end

%w{en en_US en_US_f_Allison recordings}.each do |sound|
  link "#{node['asterisk']['prefix']['state']}/lib/asterisk/sounds/#{sound}" do
    to "/usr/share/asterisk/sounds/#{sound}"
  end
end
