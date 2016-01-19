#iptables_rule 'zabbix_firewall' do
#	action :enable
#end

execute 'install dev_tools' do
	command "yum groupinstall -y 'Development Tools'"
end

# Move the source to /opt/
cookbook_file '/opt/zabbix-3.0.0alpha2.tar.gz' do
	source 'zabbix-3.0.0alpha2.tar.gz'
end

# Extract source unless it has already been extracted
unless Dir.exists? "/opt/zabbix-3.0.0alpha2"
   execute 'extract zabbix' do
	   command 'cd /opt/ && tar -xf zabbix-3.0.0alpha2.tar.gz'
   end
end

# Create zabbix group
group 'zabbix' do
	action :create
	gid '581'
end

# Create zabbix user
user 'zabbix' do
	comment 'zabbix user'
	gid 'zabbix'
	action :create
end

directory '/var/log/zabbix' do
	action :create
	mode 0755
	owner 'zabbix'
	group 'zabbix'
end

directory '/var/run/zabbix' do
	action :create
	mode 0755
	owner 'zabbix'
	group 'zabbix'
end

directory '/var/run/zabbix/subsys' do
	action :create
	mode 0755
	owner 'zabbix'
	group 'zabbix'
end

# Install dev packages to complete the compile command as is below.
package ['libxml2-devel', 'net-snmp-devel', 'libcurl-devel'] do
	action :install
end

bash 'build_zabix_agent' do
  cwd '/opt/zabbix-3.0.0alpha2'
  code <<-EOH
  ./configure --enable-agent
  make install
  EOH
  not_if { ::Dir.exists?("/usr/local/etc/zabbix_agentd.conf.d") }
end

template 'zabbix_agent_init' do
	path '/etc/init.d/zabbix_agentd'
	source 'zabbix_agentd.erb'
	mode 0775
	owner 'root'
	group 'root'
end
# Backup original zabbix config unless it has already been backed up.
unless File.exists? "/usr/local/etc/zabbix_agentd.conf.orig"
	execute 'create backup of zabbix config' do
		command 'mv /usr/local/etc/zabbix_agentd.conf /usr/local/etc/zabbix_agentd.conf.orig'
	end
end

template 'zabbix_agentd.conf' do
	path '/usr/local/etc/zabbix_agentd.conf'
	source 'zabbix_agentd.conf.erb'
	mode 0640
	owner 'root'
	group 'zabbix'
end

service 'zabbix_agentd' do
	action [:enable, :restart]
end