if File.exists? "/var/run/zabbix/zabbix_server.pid" then
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
  rm -rf /usr/local/sbin/zabbix_server
  EOH
end

bash 'build_zabix' do
  cwd "/opt/#{node['zabbix3']['version']['current']}"
  code <<-EOH
  ./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2
  make install
  EOH
end

bash 'upgrade_web_interface' do
  code <<-EOH
  rm -rf /var/www/html/zabbix/*
  cp -r /opt/#{node['zabbix3']['version']['current']}/frontends/php/* /var/www/html/zabbix
  EOH
end

template 'zabbix_server.conf.php' do
  path '/var/www/html/zabbix/conf/zabbix.conf.php'
  source 'zabbix.conf.php.erb'
  mode 0644
  owner 'root'
  group 'root'
end

service 'zabbix_server' do
  action :start
end


