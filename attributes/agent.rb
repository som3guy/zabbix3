# Zabbix agent general
default['zabbix3']['agent']['enabled'] = 'false'
# Zabbix Agent attributes
default['zabbix3']['agent']['conf']['PidFile'] = '/var/run/zabbix/zabbix_agentd.pid'
default['zabbix3']['agent']['conf']['LogFile'] = '/var/log/zabbix/zabbix_agentd.log'
default['zabbix3']['agent']['conf']['LogFileSize'] = '0'
default['zabbix3']['agent']['conf']['EnableRemoteCommands'] = '1'
default['zabbix3']['agent']['conf']['Server'] = '127.0.0.1'
default['zabbix3']['agent']['conf']['ServerActive'] = '127.0.0.1'
default['zabbix3']['agent']['conf']['Hostname'] = 'test.techhangout.net'
default['zabbix3']['agent']['conf']['Include'] = '/usr/local/etc/zabbix_agentd.conf.d/'