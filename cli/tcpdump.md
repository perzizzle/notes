``` sudo tcpdump -n -w output.pcap dst 172.26.198.123 or dst 172.26.198.124 or dst 172.26.198.125 or dst 172.26.198.126 and port 9092```

-n Don't do reverse dns lookups 

-w output to file named output.pcap 

|parameter|description|
|-------|--------|
|i| interface|
|host| ip address|
|src| source|
|dst |destination|
|port |port|
