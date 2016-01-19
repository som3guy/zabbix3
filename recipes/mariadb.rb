#Setup the mariadb repo
template 'maria_repo' do
	path '/etc/yum.repos.d/mariadb.repo'
	source 'mariadb.repo.erb'
	mode 0644
	owner 'root'
	group 'root'
end

package ['MariaDB-Galera-server', 'MariaDB-devel'] do
    action :install
end

service 'mysql' do 
	action [:enable, :start]
end

execute 'change_mysql_root_password' do
	command "mysqladmin -u root password '#{node['zabbix3']['mysql']['root_password']}'"
end

template 'my_root_cnf' do
	path '/root/.my.cnf'
	source 'my_root.cnf.erb'
	mode 0644
	owner 'root'
	group 'root'
end
