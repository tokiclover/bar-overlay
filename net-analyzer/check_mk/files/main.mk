#!/usr/bin/python
# encoding: utf-8
# vim:ft=python

###############################################################################
# CONFIGURATION ENVIRONMENT VARIABLES
# Any variable defined in /usr/share/check_mk/{modules,web/htdocs}/defaults
# can be changed here. Beware that some values are hardcoded in modules files
# or htdocs files, so a recursive sed may be necessary to get around that kind
# of bloker. This is pretty true for /pnp4nagios/ path which should be changed
# in the files in /usr/share/check_mk/web.
# However, any value changed from the default should be also changed in
# /usr/share/check_mk/web/htdocs/defaults.py or the web UI will fail badly.
nagios_command_pipe_path           = '/var/nagios/rw/nagios.cmd'
check_result_path                  = '/var/nagios/spool/checkresults'
nagios_startscript                 = '/etc/init.d/nagios'
nagios_binary                      = '/usr/sbin/nagios'
nagios_config_file                 = '/etc/nagios/nagios.cfg'
logwatch_notes_url                 = "/nagios/logwatch.php?host=%s&file=%s"
pnp_url                            = '/pnp/'
rrdcached_socket                   = '/run/rrdcached.sock'
rrd_path                           = '/var/nagios/perfdata'
livestatus_unix_socket             = '/var/nagios/rw/live'


###############################################################################
# CONFIGURATION VARIABLES   <https://mathias-kettner.de/checkmk_configvars.html>
# Letzte Aktualisierung: 11. September 2009
#
# This article gives an overview over all general configuration variables that
# can be put into main.mk. Many check types define further variables which are
# not explained here. Please refer to the check manuals for information about
# check specific configuration variables.
# 1. BASIC SETTINGS

# The basic settings influence global aspects. The most important and only
# obligatory variable is all_hosts. For each variable you'll find the default
# value after the equal sign. For more examples please look into the annotated
# example file main.mk.example which will be installed into your documentation
# directory when you setup check_mk.
#
# 1.1. CHECK_PARAMETERS
#
# This is a configuration list assigning specific check parameters to checks
# created by inventory. It is a list of rules. Each rule is a tuple of
#
#    A check parameter
#    Optional: a list of host tags.
#    A list of host names or ALL_HOSTS.
#    A list of service patterns.
#
# EXAMPLE:
# main.mk

check_parameters = [
	# (1) Filesystem C: on winsrv02 gets levels (92, 96)
	#( (92, 96), [ "winsrv02" ], [ "fs_C:" ]),
	# (2) Filesystems on hosts with tag "sap" and "test" are always OK
	#( (101, 101), [ "sap", "test" ], ALL_HOSTS, [ "fs_"]),
	# (3) Levels for filesystems below /sap (also /saptrans, /saptest)
	#( (80, 95), ALL_HOSTS, [ "fs_/sap" ]),
	# (4) Levels for filesystems /var and /tmp on all hosts
	( (90, 95), ALL_HOSTS, [ "fs_/var", "fs_/var/tmp", "fs_/tmp" ] ),
	# (5) Set levels for all remaining file systems to 80% / 90%
	( (80, 90), ALL_HOSTS, [ "fs_" ] ),
]

# 1.2. checks <https://mathias-kettner.de/checkmk_manualchecks.html>
#
# List of manually configured checks (those not found by inventory). Each entry
# of the list is four or five-tuple with the following elements:
#
#    An optional list of host tags. The entry is valid only for hosts having all of the listed tags.
#    A list of hostnames or the one of the keywords ALL_HOSTS, PHYSICAL_HOSTS, or CLUSTER_HOSTS.
#    A check type
#    A check item or the keyword None for checks that do not need an item.
#    Paramters for the check or the keyword None for checks that do not need a parameter.
#
# DEFAULT: checks = []
# EXAMPLE:

checks = [
	#( "cluster1", "df", "/",    ( 80, 90 ) ),

	# FreeBSD on ZFS
	( "freebasd-host", "zfsget", "/", ( 80, 90 ) ),
	( "freebasd-host", "zfsget", "/usr/home",    ( 80, 90 ) ),
	( "freebasd-host", "zfsget", "/usr/ports",   ( 80, 90 ) ),
	( "freebasd-host", "zfsget", "/usr/src",     ( 80, 90 ) ),
	( "freebasd-host", "zfsget", "/usr/log",     ( 80, 90 ) ),
	( "freebasd-host", "zfsget", "/usr/mail",    ( 80, 90 ) ),

	( ["linux", "snmp"],   ALL_HOSTS, "ps", "SNMPD", {
	        "user": "nobody", "process": "/usr/sbin/snmpd",
	        "warnmin": 1, "okmin": 1, "okmax": 1, "warnmax" : 1
	    } ),
	( ["freebsd"], ALL_HOSTS, "ps", "SSHD", {
	        "user": "root", "process" : "/usr/sbin/sshd",
	        "warnmin" : 1, "okmin" : 1, "okmax" : 1, "warnmax" : 1
	    } ),
	( ["linux"], ALL_HOSTS, "ps", "SSHD", {
	        "user": "root", "process" : "/usr/sbin/sshd",
	        "warnmin" : 1, "okmin" : 1, "okmax" : 1, "warnmax" : 1
	    } ),

	( ["cgroup"],   ALL_HOSTS, "ps", "CGRED", {
	        "user": "root", "process": "/usr/sbin/cgrulesengd",
	        "warnmin": 1, "okmin": 1, "okmax": 1, "warnmax" : 1
	    } ),

	# Monitors web processes by using various tags on hosts
	( ["http", "apache"],   ALL_HOSTS, "ps.perf", "Apache", {
	        "user": "apache", "process": "/usr/sbin/apache2",
	        "warnmin": 1, "okmin": 1, "okmax": 1, "warnmax" : 1
	    } ),
	( ["http", "lighttpd"],   ALL_HOSTS, "ps.perf", "LigHTTPD", {
	        "user": "lighttd", "process": "/usr/sbin/lighttpd",
	        "warnmin": 1, "okmin": 1, "okmax": 1, "warnmax" : 1
	    } ),
	( ["http", "nginx"],   ALL_HOSTS, "ps.perf", "Nginx", {
	        "user": "nginx", "process": "/usr/sbin/nginx",
	        "warnmin": 1, "okmin": 1, "okmax": 1, "warnmax" : 1
	    } ),
	( ["cgi", "nginx"],   ALL_HOSTS, "ps.perf", "FCGIWRAP", {
	        "user": "nginx", "process": "/usr/sbin/fcgiwrap",
	        "warnmin": 12, "okmin": 2, "okmax": 16, "warnmax" : 16
	    } ),
	( ["cgi", "lighttpd",],   ALL_HOSTS, "ps.perf", "FCGI-CGI", {
	        "user": "lighttpd", "process": "/usr/bin/fcgi-cgi",
	        "warnmin": 12, "okmin": 2, "okmax": 16, "warnmax" : 16
	    } ),
	( ["fpm", "apache"],   ALL_HOSTS, "ps.perf", "PHP-FPM_apache", {
	        "user": "apache", "process": "php-fpm:",
	        "warnmin": 12, "okmin": 2, "okmax": 16, "warnmax" : 16
	    } ),
	( ["fpm", "lighttpd"],   ALL_HOSTS, "ps.perf", "PHP-FPM_lighttpd", {
	        "user": "lighttpd", "process": "php-fpm:",
	        "warnmin": 12, "okmin": 2, "okmax": 16, "warnmax" : 16
	    } ),
	( ["fpm", "nginx"],   ALL_HOSTS, "ps.perf", "PHP-FPM_nginx", {
	        "user": "nginx", "process": "php-fpm:",
	        "warnmin": 12, "okmin": 2, "okmax": 16, "warnmax" : 16
	    } ),
	( ["mysql"],   ALL_HOSTS, "ps.perf", "MySQLD", {
	        "user" : "mysql", "process": "/usr/sbin/mysqld",
	        "warnmin" : 1, "okmin" : 1, "okmax" : 1, "warnmax" : 1
	    } ),
	( ["postgres"],ALL_HOSTS, "ps.perf", "PostgreSQL", {
	        "user" : "postgres", "process" : "/usr/lib/postgresql-9.6/bin/postgres",
	        "warnmin" : 1, "okmin" : 1, "okmax" : 1, "warnmax" : 1
	    } ),
]

# 1.3. agent_port
#
# TCP port the check_mk_agent is expected to listen on. Default:

agent_port = 6556

# 1.4. agent_ports

# New in 1.1.11i2: this variable allows to specify the TCP port to be used to
# connect to the agent on a per-host-basis. The syntax is the same as with
# datasource_programs. Here is an example assigning the port 6600 to all hosts
# with the tag dmz:

agent_ports += [
	#( 6650, [ "dmz" ], ALL_HOSTS ),
]

# If no entry matches, then the setting of agent_port is used.
# 1.5. tcp_connect_timeout
#
# Number of seconds after which an agent is considered to be unreachable.
# Note that the timeout is just applied to the creation of the connection.
# Once the connection is build up, no timeout can occur. Default:

tcp_connect_timeout = 5.0

# 1.6. check_mk_exit_status

# New in 1.2.3i1: This configuration ruleset allows you to override the usual 
# status codes for the active Check_MK services. One usecase is to set the
# status to OK, even if the agent does not respond (the host is down). This
# allows you to monitor hosts that do not always run without alerting. The
# value is a dictionary with various possible keys:

# Configuration Key	Situation
# connection	The agent does not respond or the host is unreachable.
# missing_sections	The agent (SNMP or Check_MK) responds but sends incomplete data
# empty_output	The Check_MK agent responds but sends empty data
# wrong_version	The Check_MK agent has a wrong version
# exception	Some unhandled exception has happened

# EXAMPLE:

#check_mk_exit_status = [
#  ( { 'connection' : 0, }, [], ALL_HOSTS ),
#]

# DEFAULT:

check_mk_exit_status = [
	( {
	  'connection'       : 2,
	  'missing_sections' : 1,
	  'empty_output'     : 2,
	  'wrong_version'    : 1,
	  'exception'        : 3,
	},
	[], ALL_HOSTS ),
]

# 1.7. do_rrd_update

# Deprecated Whether or not to do direct RRD updates. Python support for rrdtool
# must be available if set to True. Check_mk enters values directly into RRD
# databases if there are alread available under rrd_path. You still need
# PNP4Nagios to create those databases. Default:
#
#do_rrd_update = False

# This option has been removed in version 1.1.13i1.
# 1.8. delay_precompile
#
# New in 1.1.11i2: If you set delay_precompile to True, then Check_MK will not
# directly Python-bytecompile all host checks when doing -C, -U, -O or -R, but
# will delay this to the first time the host is actually checked being by Nagios.
# This reduces the time needed for the operation, but on the other hand will lead
# to a slightly higher load of Nagios for the first couple of minutes after the
# restart.
#
# Note: In order for this option to work, Nagios needs write access in the
# directory precompiled, where the precompiled host checks are stored. This
# is always the case when using OMD. The default value is False.
# EXAMPLE:

delay_precompile = False

# 1.9. perfdata_format
#
# When using MRPE, Nagios looses the information about the name of the original
# check command. As of version 1.1.4 the Linux agent (and maybe later others
# as well) send the name of the check command and the check mrpe will process
# this. In order to make that information usable by PNP4Nagios you need to set
# perfdata_format to "pnp". Other graphing tools are currently not supported.
#
perfdata_format = "pnp"

# The default value is "standard", which strictly adheres to the Nagios standards
# for performance data format and does include any information about the check
# command.

# 1.10. check_max_cachefile_age
#
# The number of seconds a cache file may be old if check_mk should use it instead
# of getting information from the target host. Per default this is disabled by
# setting the value to 0. Default:

#check_max_cachefile_age = 0

# 1.11. datasource_programs <https://mathias-kettner.de/checkmk_datasource_programs.html>
#
# This is a configuration list that allows you to define external commands as
# data sources when retrieving data from a host - instead of a TCP connection
# to the agent. Please refer to this article for details.
datasource_programs = [
        # Use default nagios SSH key with 'ssh' host tag.
        # XXX: There is no command in this case because $HOME/.ssh/authorized_keys
        # contains:
        # command="/path/to/check_mk_agent",no-port-forwarding,no-agent-forwarding,no-X11-forwarding ssh-$TYPE xxxx nagios@host'
        # for security reasons.
        # The key should not have a password for this and the '<IP>' host should
        # have: cat >/etc/[local/]sudoers.d/check_mk <<EOF
        # check_mk_agent ALL= (root) NOPASSWD: /usr/bin/check_mk_agent /usr/local/bin/check_mk_agent
        # EOF
        # Or else, root account can be used instead to avoid having an extra user
        # to configure and sudo installation and configuration!
        # SSH private keys can have password if keychain is used to setup manually
        # the keys.
	( "/usr/bin/ssh -q check_mk_agent@<IP>", ["ssh"], ALL_HOSTS ),

        # use a specific <user> and idendity file and a list of hosts
	#( "/usr/bin/ssh -i /path/to/.ssh/id_rsa -l user <IP>",
        # [ "server01", "server02" ] ),

        # Use a directly the agent on localhost instead of using xinetd/ssh.
        # Prefix the command with sudo to run the command as root, but configure
        # sudo with nagios user: cat >/etc/[local/]sudoers.d/check_mk <<EOF
        # nagios ALL = (root) NOPASSWD: /usr/bin/check_mk_agent /usr/local/bin/check_mk_agent
        # EOF
        ( "/usr/bin/sudo /usr/bin/check_mk_agent", ["localhost"] ),
]

# 1.12. www_group
#
# When the logwatch check stores log messages for review and acknowledgement
# by the logwatch web page it has to make sure, that the web server can delete
# those files. This is done by giving the directories holding the files to a
# group where both Nagios and the web server have to be in. If that group is
# not successfully autodetected during setup, you have to specify it manually
# in main.mk.
# EXAMPLE:
#
www_group = "apache"

# 1.13. simulation_mode
#
# This boolean variable allows you to bring check_mk into a dry run mode. No
# hosts will be contacted, no DNS lookups will take place and data is read
# from cache files.
# EXAMPLE:
#
#simulation_mode = True

# 1.14. debug_log
#
# If you set this to a filename, Check_MK will create a debug logfile containing
# details about failed checks (those which have state UNKNOWN and the output
# UNKNOWN - invalid output from plugin.... Per default no logfile is written.
# EXAMPLE:
#
debug_log = "/var/nagios/check_mk_debug.log"

# If you're using OMD, set it to a directory writeable for your OMD site user.
# EXAMPLE:
#
#debug_log = "/omd/sites/mysitename/var/log/check_mk_debug.log"

# 1.15. monitoring_host
#
# New in 1.1.7i2. Set this variable to the name of your monitoring (Nagios, etc.)
# host as listed in all_hosts. The default value is localhost, but this is not
# correct for all installations. This setting is currently only needed when
# scanning for parents using --scan-parents, but might be used for future
# features as well.
# EXAMPLE:
#
monitoring_host = "localhost"

# 1.16. scanparent_hosts
#
# New in 1.1.7i2. When using --scan-parents you can use this variable to reduce
# the number of hosts for which parents are autodetected. This is a binary host
# list similar to bulkwalk_hosts. It is preset to [( ALL_HOSTS, )], so that
# --scan-parents affects all hosts. The following example restricts it to
#  non-snmp hosts:
#
scanparent_hosts = [
	#( ["!snmp"], ALL_HOSTS ),
]

# 1.17. max_num_processes
#
# Maximum number of parallel processes to start when doing a parent scan. The 
# default is 50. Example: allow up to 200 processes:
#
max_num_processes = 200

# 1.18. check_submission
#
# New in 1.1.11i1: Check_MK now supports creating Nagios check files instead
# of writing into the Nagios command pipe when submitting check results.
# Creating the files reduces overhead in the Nagios core. Furthermore Check_MK
# can submit results even when Nagios is currently not running. Upto version
# 1.1.12 this variable is preset to "pipe" which uses the command pipe for
# submission. From 1.1.13i1 on the default is "file". You can set it to "file"
# for creating check files instead:
#
check_submission = "file"

# 2. SETTINGS FOR HOSTS
# 2.1. all_hosts
#
# The list of all hostnames that shall be monitored with check_mk. Hostnames
# are strings. Strings can generally be written either in single or in double
# quotes. It is legal to use an IP address instead of a hostname. Host tags
# may be added using a vertical bar. Example:

all_hosts = [
	"localhost|http|linux|snmp|v3|tcp|postgres|mysql|cgroup|cgi|fpm|apache|lighttpd|nginx",
	"vlan-router|routers|ping",
	"local-router|routers|ping",
]

# DEFAULT:
#
# all_hosts = []

# 2.2. ipaddresses
#
# If some of your hostname are not resolvable via DNS you need to specify the
# IP addresses manually. This is done with the this dictionary. Hostnames are
# the keys, IP addresses are the values. Entries in ipaddresses take precedence
# over DNS.
# EXAMPLE:
#
ipaddresses = {
	"localhost"   : "127.0.0.1",
	"vlan-router" : "172.16.14.1",
	"local-router" : "192.168.0.1",
}

# DEFAULT:
#
# ipaddresses = {}

# 2.3. dyndns_hosts
#
# Hosts listed in this binary configuration list (which is compatible to bulkwalk
# _hosts), do never do a DNS lookup but use their host name in all places where 
# otherwise the IP address would occur (also in the Nagios' host declarations).
# That way, a dynamic DNS lookup will be done whenever the host will be contacted.
#
# This is useful in two cases:
#
#    If the host's IP address dynamically changes (e.g. the host is a dialin
#    router using dynamic DNS updates)
#    If the host does not have any IP address (in that case you also have to
#    make sure that the standard host check command is not used).
#
# EXAMPLE:

dyndns_hosts = [
	# All hosts with the TAG "dyndns"
	( [ "dyndns" ], ALL_HOSTS ),
	# Three explicit hosts
	#( [ "hosta", "hostb", "hostc" ], ),
]

# 2.4. use_dns_cache

# New in 1.2.3i1: If this option is set to True - which is now the default -
# then all successful DNS lookups will be cached in the the ipaddresses.cache
# below Check_MK's var directory. If during configuration generation an IP
# address is found in the cache, then no DNS lookup will be done. This can speed
# configuration generation a lot, if you have a larger number of hosts. When use
# _dns_cache is set to False, then the cache will only be used in case of failed
# DNS. This makes sure that the configuration generation can be done even in
# times of an unavailable DNS. Please note that Check_MK never does any DNS
# lookups during the actual checking anyway.
#
# The DNS cache of all hosts can be updated with the new command cmk --update-dns-cache.
#
# root@linux# cmk -v --update-dns-cache
#
# If your IP addresses change frequently then you can do this with a cron job.
# 2.5. only_hosts
#
# This is a binary host list simular to snmp_hosts. If you set this variable,
# then you limit check_mk to those hosts specified in the list. This is useful
# for testing your installation with just some of your hosts. Example:
#
only_hosts = [
	# all hosts with tag "test"
	#( ["vlan"], ALL_HOSTS ),
	# and: two single special hosts (do not omit the comma
	# in the one-tuple!
	#( ["localhost", "vne4-router"], )
]

# 2.6. ping_levels
#
# New in version 1.1.13i1: This configuration list allows to specify parameters
# that are used for host checks (host checks are done with check_icmp in Check_MK).
# It is a configuration list with dictionary items with the following keys:
# Option	type	Default	Meaning
# packets 	Integer	5	Number of packets to send
# loss	2 percentages	(80,100) 	Warn and critical levels for packet loss
# in percent
# rta	2 numbers	(200, 500) 	Warn and critical levels for the round trip
# average in milli seconds
# timeout	Integer	10	Total timeout of the host check in seconds
#
# The following example set specific RTA levels for all hosts with the tag wan:
#
ping_levels += [
	# Set RTA levels to 2/4 sec
	( { "rta" : (2000, 4000) }, [ "wan" ], ALL_HOSTS ),
]

# 2.7. host_check_commands
#
# New in version 1.2.3i1: This configuration list allows you to define an alter
# native method for the host check. The default is "ping", which uses the
# standard mechanism. Here are all possible values:
#
# Value	Method for determining the host state
# "ping"	use the classical PING check (check_icmp)
# "ok"	set the host to always UP
# "agent"	use the state of the service Check_MK on the same host as host state
# ("service", "foo")	the same, but use the service foo instead.
# ("tcp", 4711)	try a TCP connect to port 4711 for checking the host state.
#
# EXAMPLE:
#
host_check_commands += [
	( ("tcp", "80"), ["http"], ALL_HOSTS ),
	( ( "service", "ssh"), ["freebsd"], ALL_HOSTS ),
]

# 3. SETTINGS FOR SERVICES
# 3.1. check_periods
#
# New in 1.2.1i4: With this configuration you can restrict the execution of
# Check_MK checks a certain time period. This does not influence the agent,
# but it prevents check results from being computed and sent to Nagios. Set
# None or 24X7 for disabling the limitation. The following example restricts
# services that begin with Fileinfo /var/backup or fs_/backup to the timeperiod 
# afterbackup. You need to make sure that this timeperiod is present in Nagios.
# If not, the check will always be executed.
#
check_periods += [
	( "afterbackup", ALL_HOSTS, [ "Fileinfo /var/backup", "fs_/backup" ] ),
]

# 4. GENERATION OF NAGIOS' CONFIGURATION FILES
#
# All variables in this section influence the generation of the Nagios
# configuration files by check_mk. They are not relevant during normal operation
# of Nagios. Many of these support host tags. Per default - all configuration
# lists are empty ([])
# 4.1. host_groups
#
# Adds hostgroup definitions to Nagios' hosts. Hosts can be in more than one group.
# The definition of the hostgroups themselves is not done by check_mk. You've to
# create them manually in your Nagios configuration. Example:
#
host_groups = [
	( "nrpe-servers",       ["nrpe"], ALL_HOSTS ),
	( "snmp-servers",       ["snmp"], ALL_HOSTS ),
	( "linux-servers",      ["linux"], ALL_HOSTS ),
	( "http-servers",       ["http"], ALL_HOSTS ),
	( "vlan-hosts",         ["vlan"], ALL_HOSTS ),
	( "freebsd-servers",    ["freebsd"], ALL_HOSTS ),
	( "routers",            ["router"], ALL_HOSTS ),
	( "switches",           ["switch"], ALL_HOSTS ),
	# All non-cluster hosts go into the host group 'hosts'
	( "hosts", ["!vlan?", "!router", "!switch"], ALL_HOSTS ),
	( "guests", ["vlan?"], ALL_HOSTS ),
	# The host-group 'test' just contains the hosts ab17 and ab18
	#( "test",     [ "ab17", "ab18" ] ),
	# All hosts (even ab17 and ab18) go into host group "ALL_HOSTS"
	( "all",      ALL_HOSTS ),
]

# 4.2. host_contactgroups
#
# Defines contact_group entries for hosts. This works exaclty like host_groups.
# The contact_group definitions must be created manually in the Nagios configuration.
#
host_contactgroups = [
	( "snmp",       ["snmp"], ALL_HOSTS ),
	( "linux",      ["linux"], ALL_HOSTS ),
	( "httpd",      ["httpd"], ALL_HOSTS ),
	( "freebsd",    ["freebsd"], ALL_HOSTS ),
	# The host-group 'test' just contains the hosts ab17 and ab18
	#( "test",     [ "ab17", "ab18" ] ),
	# All hosts (even ab17 and ab18) go into host group "ALL_HOSTS"
	( "all",      ALL_HOSTS ),
]

# 4.3. parents
#
# Defines parent hosts of hosts. This works exacly like host_groups. Multiple
# parents may be specified in one comma separated string. Example:
#
parents = [
	# All hosts with the Tag "vlan-hosts" has sw01 and sw02 as parents
	( "vlan-router", ["vlan"], ALL_HOSTS ),
]

# 4.4. service_groups
#
# This variable adds Nagios service_group definitions to Services. The service
# groups themselves have to be created manually in the Nagios configuration.
# The difference to host_groups is, that each entry contains in addition a list
# of service descriptions, that specify which services should go into the group.
# This lists contains prefixes of services descriptions (as seen in the Nagios
# web interface). The strings are evaluated as extended regular expressions.
# An empty pattern "" matches all services. Example:
#
service_groups = [
	# All services beginning with "fs" on hosts with the tag "vlan-hosts"
	# go into the service group "vlanfs".
	( "vlanfs",  ["vlan"], ALL_HOSTS, [ "fs" ] ),
	# Put *all* services of sw01 and sw02 into the service
	# group "switches"
	( "switches", ["switch"], ALL_SERVICES ),
	( "routers",  ["router"], ALL_SERVICES ),
	# Put services with the exact description "fs_/var$" into
	# the group var (and exclude "fs_/var/log", etc.)
	#( "var", ALL_HOSTS, ["fs_/var$"] ),
	( "filesystems", ALL_HOSTS, ["fs", "LOG", "zpool", ".*zfs"] ),
	( "disks", ALL_HOSTS, ["RAID", "Raid", "Disk"], ),
	( "httpd", ALL_HOSTS, ["Apache", "MySQL", "PostgreSQL"] ),
	( "sensors", ALL_HOSTS, ["Humidity", "Temperature", "Airflow", "Power",
	  "Phase", "Fanspeed", "Module", "PDU", "APC", "Self Test", "FAN", "CPU",
	  "Fan", "Sensor", "SMART",], ),
	# Put various processes of hosts with the tag "linux" into
	# the group "processes":
	( "processes", ["linux"], ALL_HOSTS, ["proc"] ),
	# Build a group of services containing the substring K15
	( "zfs", ALL_HOSTS, [".*zfs"]),
	    ( "all", ALL_HOSTS, ALL_SERVICES ),
]

# 4.5. service_contactgroups
#
# Add contact_group definitions to the Nagios services. This works exactly like
# service_groups.
# 4.6. extra_host_conf
#
# This is a dictionary that allows you to define arbitrary Nagios variables in
# your host definitions. The keys into the dictionary are the Nagios directives
# to set. The values are a configuration lists similar to datasource_programs.
# The following example add a variable icon_image to some of the hosts (the file
# should be saved in images/icons/):
#
extra_host_conf["icon_image"] = [
	( "linux.png", ["linux"], ALL_HOSTS ),
	( "windows.png", ["windows"], ALL_HOSTS ),
	( "special.png", [ "host123", "host345" ] )
]

# 4.7. extra_service_conf
#
# This variable is a dictionary that allows you to define arbitrary Nagios
# variables in your service definitions. The keys into the dictionary are the
# Nagios directives to set. The values are configuration lists similar to
# extra_host_conf but needs a list of service patterns. The following example
# configures flap detection for all services on SNMP hosts the begin with NIC
# or Interface:
#
extra_service_conf["flap_detection_enabled"] = [
	( "1", ["snmp"], ALL_HOSTS, ALL_SERVICES ),
	( "1", ["nrpe"], ALL_HOSTS, ALL_SERVICES ),
	( "1", ALL_HOSTS, ["NIC", "Interface"] )
]
extra_service_conf["check_interval"] = [
	( "1", ["router"], ALL_HOSTS, ALL_SERVICES ),
	( "1", ["switch"], ALL_HOSTS, ALL_SERVICES ),
]

# 4.8. service_descriptions
#
# Check_MK assigns its own scheme of services descriptions for all services it
# generates. Filesystem checks - as an example - always begin with fs_. This
# configuration variable allows to define custom name patterns for all check
# types. Check types with an item (such as df: the item is the mount point of
# the filesystem) must have exactly one %s in the description. That will be
# replaced with the item. Check types without an item (such as cpu.loads) must
# not have a %s. The following example assigns custom service descriptions to
# the check types df and cpu.loads:

service_descriptions = {
	"cpu.loads" : "CPU Load average",
	"cups_queues" : "Printer %s",
	"df"        : "Filesystem %s",
	"fileinfo"  : "FILE %s",
	"fileinfo.groups" : "FILE GROUP %s",
	"ps"        : "PROC %s",
	#"mounts"    : "Mount options %s",
	#"lnx_thermal" : "Temperature %s",
	#"logwatch"  : "LOG %s",
	#"nfsmount"  : "NFS mount %s",
	"check_mk_pingonly": "PING",
}

# Please call check_mk -L for a list of all known check types and their default
# service description patterns. There you will also learn which check types await
# a %s and which not.
# 4.9. service_dependencies
#
# Creates Nagios service_dependency definitions between services of the same host.
# Please refer to examples in a dedicated article.
# ARTICLE: <https://mathias-kettner.de/checkmk_service_dependencies.html>
#
service_dependencies = [
	( "PING", ALL_HOSTS, ALL_SERVICES ),
]

# 4.10. define_hostgroups
#
# This variable controls, whether hostgroups that you assign with host_groups are
# automatically created in your Nagios configuration. Per default, no host groups
# will be created. If you set define_hostgroups to True, then all host groups
# referred to by host_groups will be created with the alias equal to the name.
#
# Alternatively you can make this variable a dictionary from host group names
# to their aliases. Please note, that only those host groups are created that
# are referred to by your configuration, even if more appear in the dictionary.
# Referred host groups not appearing in the dictionary will be created with
# their names as aliases. Example:
#
# Create all needed host groups
define_hostgroups = True

# Alternative: define aliases for some host groups
define_hostgroups = {
	"http-servers"   : "HTTP Servers",
	"linux-servers"   : "Linux Servers",
	"freebsd-servers" : "FreeBSD Servers",
	"routers"    : "Network routers",
	"switches"   : "Network switches",
	"all-hosts"  : "All hosts",
}

# 4.11. define_servicegroups

# This variable controls, whether service groups referred to by service_groups
# are automatically created in your Nagios configuration. Per default no groups
# are created. This variable works exaclty like define_hostgroups. Example:

define_servicegroups = {
	"oracle" : "ORACLE services",
	"ports"  : "Switch ports",
	"filesystems" : "Filesystems",
	"databases"   : "Databases",
	"httpd" : "HTTP web services",
	"sensors" : "Sensors",
	"disks" : "Disks",
}

# 4.12. define_contactgroups

# Setting this variable to True will make check_mk -U, -O and -R automatically
# create definitions for all contact groups referred to by any host or service
# handled by Check_MK. Just as with define_hostgroups and define_servicegroups
# you can alternatively set this variable to a dictionary and thus define
# aliasses. Example:

# Just define contactgroups without aliases
define_contactgroups = True

# Alternative: define aliases for (some) contactgroups
# (all other contactgroups will get their name as alias)
define_contactgroups = {
	"admins" : "Administrators",
	"unix"   : "UNIX Administrators",
	"linux" : "Linux Admnistrators",
}

# Please note, that contact group definitions are not output, when using
# check_mk -H or check_mk -S.
# 4.13. contactgroup_members

# New in 1.2.2: With this dictionary variable you can directly specify a list of
# (additional) members of a contact group. This is directly put as a members
# line into the Nagios configuration of that contact group. Note: If the contact
# group has no hosts/services it will not be defined nevertheless. Example:

contactgroup_members["admins"] = [ "harri", "sepp", "charles", "mrnobody" ]
contactgroup_members["linux"] = [ "harri", "sepp", "charles", "mrnobody" ]
contactgroup_members["unix"] = [ "kernighan", "richie", "thomson" ]

# 4.14. nagios_illegal_chars

# Lists charactes that must not appear in Nagios' service_description definitions.
# Check_mk automatically removes those characters when creating the Nagios
# configuration. Please think twice if you remove characters from this list. Default:

nagios_illegal_chars = '`~!$%^&*|\'"<>?,()='

# Please note, that in this default settings the backslash is allowed. It is just
# needed in the Python string in order to quote the single quote.
# 4.15. logwatch_notes_url

# URL pointing to the logwatch web page logwatch.php. For each logfile monitoring
# service check_mk automatically adds a notes_urls entry. The entry must contain
# exaclty two times %s. The first occurrance is replaced with the host name, the
# second one with the service description (URL encoded). The default value is set
# by setup.sh. If the autodetection does not work properly, you can tune it
# manually. In such a case the default value is:

logwatch_notes_url = "/nagios/logwatch.php?host=%s&file=%s"

# 4.16. generate_hostconf

# Setting this variable to False supresses the generation of host definitions
# when creating configuration files for Nagios. This affects the options -U,
# -O and -R. Example:

generate_hostconf = False

# 4.17. generate_dummy_commands

# Setting this variable to False supresses the generation of command definitions
# for the passive checks, when generating configuration files for Nagios. Those
# dummy commands are never execute but referred to by the service definitions.
# This allows you to select PNP4Nagios templates according to the check type.
# Setting this variable to False is neccessary in order to avoid duplicate
# definitions when merging outputs of multiple instances of check_mk together.
# Note: The check_command directives in the service definitions are always
# generated - regardless of the setting of generate_dummy_commands. Example:

generate_dummy_commands = True

# 5. Inventory and Inventory checks

# The following variables control inventory. Further check specific parameters
# for inventory exist. Those are described in the man pages of those checks.
# 5.1. ignored_checktypes

# List of check types that should be ignored when doing an inventory with
# check_mk -I alltcp or an inventory check with check_mk --check-inventory.
# They still can be inventorized explicitely, for example with check_mk -I df
# HOSTNAMES. Per default no check types are ignored. Example:

ignored_checktypes = [ "netctr", "ipmi" ]

# 5.2. ignored_services

# An item-less configuration list (you can use host tags) that allows to exclude
# certain services on certain hosts from inventory. This has no effect on already
# existing services. Per default no services will be excluded from inventory.
# Please visit the article about inventory for details. Example:

ignored_services = [
	( [ "windows" ], ALL_HOSTS, [ "LOG", "fs_C:" ] ),
	( [ "linux" ], ALL_HOSTS, [ "fs_/tmp" ] )
]

# 5.3. ignored_checks

# NEW in 1.1.9i1 List of check types that should be ignored for one or several
# hosts specified as explicit list of hostnames or as tags. This option is
# recognized during inventory only. The ignored checks still can be inventorized
# explicitely, for example with check_mk --checks=df -I HOSTNAMES. Per default
# no check types are ignored. Example:

ignored_checks = [
	( "df",                            [ "windows" ]),
	( [ "hr_cpu", "hr_mem", "hr_fs" ], [ "linux" ], ALL_HOSTS),
]

# 5.4. inventory_max_cachefile_age
#
# Inventory is greatly sped up by using cache files. That makes use of the fact
# that check_mk saves agent information to a file for each host after each check.
# Per default, that file is being used if it is not older then 120 seconds. If
# you changed your normal_check_interval for the active check_mk checks to a
# value greater than one minute, you might have to adjust this to a larger value
# in order to prevent the inventory from fetching data from the agents directly.
# EXAMPLE:
#
# Use cache files for inventory even if up to 4 min old.
inventory_max_cachefile_age = 300 # seconds

# 5.5. always_cleanup_autochecks
#
# If this variable is set to True then Check_MK always cleans up autochecks after
# each inventory. This does the same as adding the option -u to -I. Note: from
# version 1.2.3i1 on this setting defaults to True.
always_cleanup_autochecks = True

# 5.6. inventory_check_interval
#
# Setting this variable to a number of minutes enables inventory checks.
# Check_MK will then automatically create one active check per host that will
# make sure that no un-inventorized services exist for that host. Default is
# None, which switches off inventory checks.
# EXAMPLE:
#
# Do an inventory check every two hours
#inventory_check_interval = 120 # minutes

# 5.7. inventory_check_severity
#
# If an inventory check finds un-inventorized services on a host it usually
# results in a CRITICAL state. You can change this to WARNING or OK by settings
# this to 1 or 0 here.
# EXAMPLE:
#
# failing inventory checks should just warn
inventory_check_severity = 1

# Note: from version 1.1.9i1 on, the inventory_check_severity defaults to 1 (WARNING).
# 5.8. inventory_check_do_scan
#
# New in 1.2.3i5: The inventory check for SNMP devices now always does a scan
# for new check types - just as cmk -I does. That way you will be warned if a
# host is not inventorized at all or if some check types are missing for that
# host (e.g. after an update to a new Check_MK version). You can switch this
# this back to the old behaviour via
#
# Do no SNMP scan during inventory check
inventory_check_do_scan = False

# 6. SNMP <https://mathias-kettner.de/checkmk_snmp.html>
#
# The following variables are relevant if you use check_mk for SNMP monitoring.
# 6.1. snmp_default_community
#
# Default SNMP community when contacting hosts.
# DEFAULT:

snmp_default_community = "public"

# 6.2. snmp_communities

# If some of your hosts need another SNMP community than your default, you can
# set them with this variable. It is a configuration list and allows host tags.
# It is compatible to datasource_programs.
# EXAMPLE:
# main.mk

snmp_communities = [
        # use SNMP v3 credentials for host tagged 'snmp' and 'v3'
	( ( "authPriv", "SHA", "snm-user", "authPassword", "AES", 
	    "privPassword" ), ["v3"], ALL_HOSTS ),
	# all hosts with the tag "vlan" have to community "vlan-SNMP"
	( "vlan-SNMP", ["vlan"], ALL_HOSTS ),
	# The two single hosts localhost, local-router have "local-SNMP"
	( "local-SNMP",   ["localhost", "local-router"] ),
	# all other hosts have the snmp_default_community
]

# 6.3. snmp_hosts
#
# This is a item-less configuration list that specifies, which hosts should not
# be contacted via TCP when doing inventory. The default is to mark all hosts
# with the host tag snmp as SNMP hosts:
#
snmp_hosts = [ (['snmp'], ALL_HOSTS) ]

# In rare cases you might want to define snmp_hosts yourself. Here is an example:

snmp_hosts += [
	# explicit list of hosts. Important: the comma after the list!
	#( ["switch01", "switch02"], ), # do not try TCP on these two
	# use host tags: all hosts with tag 'snmp-servers', except those with tag 'both'
	( ["snmp", "!both"], ALL_HOSTS ),
	# all other hosts will be contacted with TCP on inventory
]

# If you have hosts that are monitored via SNMP and TCP, then you must not
# declare them as SNMP hosts.
# 6.4. bulkwalk_hosts
#
# This item-less configuration list determines, which hosts support SNMP v2c and
# should use snmpbulkwalk instead of snmpwalk. Please refer to the manual page
# of that command for further details. Bulk walk is faster then the normal
# snmpwalk, since it is able to fetch several variables at once in one UDP
# packet. Unfortunately, it is not supported by all SNMP devices. Per default,
# check_mk uses bulk walk for all devices. If you come along devices not
# supporting bulk walk, please use this variable to define hosts supporting
# bulkwalk.
# EXAMPLE: All hosts with the tag bulk support bulk walk, except the host broken123:
#
bulkwalk_hosts = [
	#( NEGATE, [ "broken123" ] ),
	( ["snmp", "!v1"], ALL_HOSTS )
]

# Please note, that using bulk walk implies switching to SNMP v2c and also
# enabled 64 bit data types (needed for the checks if64, and df_netapp).

# 6.5. snmpv2c_hosts
#
# New in 1.1.13i3: This variable works similar to bulkwalk_hosts, but allows
# you to just select SNMP v2c without activating bulk walk at the same time.
# This is useful for a small number of broken devices that support v2c but
# behave badly when using bulk walk.
snmpv2c_hosts = [ (['v2c'], ALL_HOSTS) ]

# 6.6. snmp_ports
#
# New in 1.1.11i2: This configuration variable allows you to specify the UDP
# port to be used for SNMP (on a per-host basis). Changing that port number is
# rarely needed, but if you are forced to use a non-standard port for some
# reason, well, you are forced to. Because we are not aware of any useful
# workaround to this problem, this option has been introduced. It is compatible
# to datasource_programs. The following example forces the port 555 to be used
# for all hosts having the tag dmz. Other hosts use the standard port:
#
snmp_ports += [
	( 161, [ "snmp" ], ALL_HOSTS ),
	#( 555, [ "dmz" ], ALL_HOSTS ),
]

# 6.7. snmp_timing
#
# New in 1.2.0: The configuration ruleset allows you to configure timeout in
# seconds and retries for SNMP request on a per-host basis, as you can see in
# the following example. Both keys timeout and retries are of type integer an
# optional.
#
snmp_timing += [
	# Special settings for hosts with the tag 'wan'
	( {'retries': 10, 'timeout': 2}, ['wan'], ALL_HOSTS ),
]

# 6.8. snmp_character_encodings

# New in 1.1.11i3: Some devices send texts in non-ASCII characters. Check_MK
# always assumes UTF-8 encoding, but some devices implicitely use other
# encodings, like latin1. It is now possible to declare such hosts in main.mk
# with their encodings, so that strings like Resttonerbehälter can be properly
# displayed. snmp_character_encodings works like datasource_programs.
# Example for western encoding:
#
# Assume all devices with tags snmp-servers and printer to use latin1 encoding
snmp_character_encodings += [
	#( "latin1", [ "snmp", "printers" ], ALL_HOSTS ),
]

# Note: There may still be some checks that do not honor this setting. If you
# find such a check, please contact the mailing list and post an SNMP-walk of
# such a device.
# 6.9. usewalk_hosts
#
# Using stored snmpwalks when checking SNMP hosts is a useful feature for
# testing, debugging and implementing checks. This can be triggered manually
# with the option --usewalk. If you want certain hosts to use stored checks in
# general, you can declare them in usewalk_hosts. Its syntax is identical to
# bulkwalk_hosts. Example (here without tags):
#
usewalk_hosts = [
	#( [ "testhost1", "testhost2" ] ),
]

# 6.10. snmp_check_interval

# New in version 1.2.3i1: This option can be used to customize the check
# intervals of SNMP based checks. You can use it to perform one or several
# SNMP based checks less frequent than others. This is a binary host list,
# where the first matching value is used as check interval. For example if
# you like to perform all if-checks on a host named switch every two minutes
# instead of every single minute:
#
snmp_check_interval = [
	( ('if', 2), [], ['switch'] ),
	( ('.*', 1), [], ['router'] ),
]

# 7. Cluster checks
# 7.1. clusters
#
# Definition of HA clusters.
# DEFAULT:

clusters = {}

# 7.2. clustered_services
#
# Definition of services that should be considered as being clustered.
# Default:
#
clustered_services = []

# 7.3. clustered_services_of

# This does the same as clustered_services but is a dictionary and allows you
# to explicitely specify a cluster, the services should be assigned to. You
# need this only if you clusters overlap. Example:
#
clustered_services_of["ora02"] = [
	( ALL_HOSTS, [ "fs_/ora" ] ),
]

# 7.4. cluster_max_cachefile_age
#
# The number of seconds a cache file may be old if check_mk should use it
# instead of getting information from the target hosts while checking a cluster.
# Per default this is enabled and set to 90 seconds. If your check cycle is not
# set to a larger value then one minute then you should increase this accordingly.
# DEFAULT:
#
cluster_max_cachefile_age = 300


