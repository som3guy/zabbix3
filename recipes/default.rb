#
# Cookbook Name:: zabbix3
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
if node['zabbix3']['server']['enabled'] == 'true' then
    include_recipe 'zabbix3::mariadb'
end

if node['zabbix3']['mysql']['enabled'] == 'true' then
    include_recipe 'zabbix3::server'
end

if node['zabbix3']['agent']['enabled'] == 'true' then
    include_recipe 'zabbix3::agent'
end