snmp
====

Install
-------
1. sudo yum install net-snmp net-snmp-utils
2. Copy mibs to path returned by:
  * net-snmp-config --default-mibdirs

Use snmpwalk to test
---------------------
* -v version
* -c community
* ip address
* oid

### Examples
```
# Get a single field
snmpget -v1 -c community_name ip_address IP-MIB::ipReasmTimeout.0

# Walk a snmp tree
snmpwalk -v1 -c community_name ip_address .1.3.6.1.2.1.6.14

# Translate an oid to human readable
snmptranslate .1.3.6.1.2.1.2.2
IF-MIB::ifTable
```

### References
------
https://mibs.observium.org/mib/RFC1213-MIB/
https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-11-3-0/8.html
https://support.solarwinds.com/Success_Center/Network_Performance_Monitor_(NPM)/What_OIDs_are_polled_for_F5_statistics
https://somoit.net/f5-big-ip/f5-big-ip-useful-snmp-oids-monitor
https://samtech.tech/monitoring-network-devices-with-influxdb-telegraf-chronograf/





