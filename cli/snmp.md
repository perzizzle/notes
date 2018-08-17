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

``` snmpwalk -mALL -v2c -c influx 172.26.225.144 .1.3.6.1.4.1.3375.2.2.5.3.2.1.11 ```

F5 Links
------
https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/bigip-external-monitoring-implementations-11-3-0/8.html
https://support.solarwinds.com/Success_Center/Network_Performance_Monitor_(NPM)/What_OIDs_are_polled_for_F5_statistics
https://somoit.net/f5-big-ip/f5-big-ip-useful-snmp-oids-monitor
https://samtech.tech/monitoring-network-devices-with-influxdb-telegraf-chronograf/





