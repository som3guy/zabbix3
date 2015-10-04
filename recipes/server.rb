#Setup firewall for zabbix
iptables_rule 'zabbix_firewall' do
	action :enable
end

# Disabled selinux
template 'selinux_config' do
	path '/etc/selinux/config'
	source 'zabbix_selinux.erb'
	mode 0644
	owner 'root'
	group 'root'
end

# Install the devtools for compling from source.
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

# Install dev packages to complete the compile command as is below.
package ['libxml2-devel', 'net-snmp-devel', 'libcurl-devel'] do
	action :install
end


bash 'build_zabix' do
  cwd '/opt/zabbix-3.0.0alpha2'
  code <<-EOH
  ./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2
  make install
  EOH
  not_if { ::Dir.exists?("/usr/local/etc/zabbix_server.conf.d") }
end
# Configure unless makefile already exists.
#unless File.exists? "/opt/zabbix-3.0.0alpha2/Makefile"
#	execute 'create zabbix from source' do
#		command 'cd /opt/zabbix-3.0.0alpha2/ && ./configure --enable-server --enable-agent --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2'
#	end
#end

# Make only if make file exists and check to see if zabbix config exists.
# Zabbix config only exists if make install already completed.

#unless Dir.exists? "/usr/local/etc/zabbix_server.conf.d"
#	execute '/opt/zabbix-3.0.0alpha2/make install' do
#		command 'make install'
#	end
#end


# Backup original zabbix config unless it has already been backed up.
unless File.exists? "/usr/local/etc/zabbix_server.conf.orig"
	execute 'create backup of zabbix config' do
		command 'mv /usr/local/etc/zabbix_server.conf /usr/local/etc/zabbix_server.conf.orig'
	end
end

# Setup the database for zabbix
mysqluser = node['zabbix3']['server']['conf']['DBUser']
mysqlpassword = node['zabbix3']['server']['conf']['DBPassword']
unless Dir.exist? "#{node['zabbix3']['mysql']['zabbix_dir']}"
   execute 'prep_mysql_db' do
	   command "mysql -e \"create database zabbix character set utf8 collate utf8_bin; grant all privileges on zabbix.* to #{mysqluser}@localhost identified by '#{mysqlpassword}';\""
   end
end

unless File.exist? "#{node['zabbix3']['mysql']['zabbix_dir']}/maintenances.frm"
   execute 'mysql_import_schema' do
	   command "mysql -u#{node['zabbix3']['server']['conf']['DBUser']} -p#{node['zabbix3']['server']['conf']['DBPassword']} zabbix < #{node['zabbix3']['mysql']['zabbix_prep_dir']}/schema.sql"
   end

   execute 'mysql_import' do
	   command "mysql -u#{node['zabbix3']['server']['conf']['DBUser']} -p#{node['zabbix3']['server']['conf']['DBPassword']} zabbix < #{node['zabbix3']['mysql']['zabbix_prep_dir']}/images.sql"
   end

   execute 'mysql_import_data' do
	    command "mysql -u#{node['zabbix3']['server']['conf']['DBUser']} -p#{node['zabbix3']['server']['conf']['DBPassword']} zabbix < #{node['zabbix3']['mysql']['zabbix_prep_dir']}/data.sql"
   end
end

# Setup zabbix server config
template 'zabbix_server.conf' do
	path '/usr/local/etc/zabbix_server.conf'
	source 'zabbix_server.conf.erb'
	mode 0640
	owner 'root'
	group 'zabbix'
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

package 'httpd' do
	action :install
end

directory '/var/www/html/zabbix' do
	action :create
	mode 0755
	owner 'zabbix'
	group 'zabbix'
end

unless File.exists? "/var/www/html/zabbix/zabbix.php"
	execute 'copy php dir to htdocs' do
		command 'cp -r /opt/zabbix-3.0.0alpha2/frontends/php/* /var/www/html/zabbix'
	end
end


template 'zabbix_server' do
	path '/etc/init.d/zabbix_server'
	source 'zabbix_server.erb'
	mode 0775
	owner 'root'
	group 'root'
end

package 'centos-release-SCL' do
	action :install
end

package ['php54', 'php54-php-common', 'php54-php-mbstring', 'php54-php-mysqlnd', 'php54-php-odbc', 'php54-php-xml', 'php54-php-gd', 'php54-php-cli', 'php54-php-pdo', 'php54-php-bcmath', 'php54-php']  do
  action :install
end

#execute 'enable_php' do
#	command 'source /opt/rh/php54/enable'
#end

unless File.exists? "/opt/rh/php54/root/etc/php.ini.orig"
	execute 'backup_php' do
		command 'mv /opt/rh/php54/root/etc/php.ini /opt/rh/php54/root/etc/php.ini.orig'
	end
end

template 'php.ini' do
	path '/opt/rh/php54/root/etc/php.ini'
	source 'php.ini.erb'
	mode 0644
	owner 'root'
	group 'root'
end

template 'zabbix_server.conf.php' do
	path '/var/www/html/zabbix/conf/zabbix.conf.php'
	source 'zabbix.conf.php.erb'
	mode 0644
	owner 'root'
	group 'root'
end


service 'zabbix_server' do
	action [:enable, :start]
end

service 'httpd' do
	action [:enable, :restart]
end
