default['zabbix3']['server']['listen_port'] = '10051'

#PHP settings
default['zabbix3']['php']['timezone'] = 'America/Chicago'
default['zabbix3']['php']['zabbix_listen'] = 'localhost'
default['zabbix3']['php']['server_name'] = ''

## All of these will show up in the zabbix server config
default['zabbix3']['server']['conf']['CacheSize'] = '8M'
default['zabbix3']['server']['conf']['CacheUpdateFrequency'] = '60'
default['zabbix3']['server']['conf']['DBHost'] = 'localhost'
default['zabbix3']['server']['conf']['DBName'] = 'zabbix'
default['zabbix3']['server']['conf']['DBUser'] = ''
default['zabbix3']['server']['conf']['DBPassword'] = ''
default['zabbix3']['server']['conf']['DBSocket'] = '/var/lib/mysql/mysql.sock'
default['zabbix3']['server']['conf']['HistoryCacheSize'] = '8M'
default['zabbix3']['server']['conf']['HistoryTextCacheSize'] = '16M'
default['zabbix3']['server']['conf']['ListenIP'] = '0.0.0.0'
default['zabbix3']['server']['conf']['LogFile'] = '/var/log/zabbix/zabbix_server.log'
default['zabbix3']['server']['conf']['LogFileSize'] = '0'
default['zabbix3']['server']['conf']['LogSlowQueries'] = '0'
default['zabbix3']['server']['conf']['PidFile'] = '/var/run/zabbix/zabbix_server.pid'
default['zabbix3']['server']['conf']['StartDBSyncers'] = '4'
default['zabbix3']['server']['conf']['StartDiscoverers'] = '1'
default['zabbix3']['server']['conf']['StartHTTPPollers'] = '1'
default['zabbix3']['server']['conf']['StartPollers'] = '5'
default['zabbix3']['server']['conf']['StartPollersUnreachable'] = '1'
default['zabbix3']['server']['conf']['StartTimers'] = '1'
default['zabbix3']['server']['conf']['StartTrappers'] = '5'
default['zabbix3']['server']['conf']['TrendCacheSize'] = '4M'
default['zabbix3']['server']['conf']['ValueCacheSize'] = '8M'
default['zabbix3']['server']['conf']['SNMPTrapperFile'] = '/var/log/snmptt/snmptt.log'

#Directory Settings
default['zabbix3']['lockfile_dir'] = '/var/run/zabbix/subsys'
default['zabbix3']['']

# Version settings
default['zabbix3']['version']['previous_file'] = 'zabbix-3.0.0beta2.tar.gz'
default['zabbix3']['version']['current_file'] = 'zabbix-3.0.1.tar.gz'
default['zabbix3']['version']['current'] = 'zabbix-3.0.1'
default['zabbix']['version']['previous'] = 'zabbix-3.0.0beta2'

