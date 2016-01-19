if File.exists? "/var/run/zabbix/zabbix_agent.pid" then
  service 'zabbix_server' do
    action :stop
  end
end

# Move the source to /opt/
cookbook_file "/opt/#{node['zabbix3']['version']['current_file']}" do
  source node['zabbix3']['version']['current_file']
end

unless Dir.exists? "/opt/#{node['zabbix3']['version']['current']}"
   execute 'extract zabbix' do
     command "cd /opt/ && tar -xf #{node['zabbix3']['version']['current_file']}"
   end
end

bash 'remove_old_zabbix_services' do
  code <<-EOH
  rm -rf /usr/local/sbin/zabbix_a*
  EOH
end

bash 'build_zabix_agent' do
  cwd "/opt/#{node['zabbix3']['version']['current']}"
  code <<-EOH
  ./configure --enable-agent
  make install
  EOH
end

template 'zabbix_agentd.conf' do
  path '/usr/local/etc/zabbix_agentd.conf'
  source 'zabbix_agentd.conf.erb'
  mode 0640
  owner 'root'
  group 'zabbix'
end

service 'zabbix_agentd' do
  action :start
end
