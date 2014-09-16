#!/bin/sh

echo "即将创建WiFi热点，请确保dhcpd.conf已经配置好！" &
sleep 5

ifconfig wlan0 down #wlan0修改成你的网卡
iwconfig wlan0 mode monitor
ifconfig wlan0 up

airmon-ng start wlan0 &
sleep 5
airbase-ng -e FreeWiFi -c 6 mon0 & #修改成自己的热点名称和信道
sleep 5

ifconfig at0 up
ifconfig at0 10.0.0.1 netmask 255.255.255.0
ifconfig at0 mtu 1400
route add -net 10.0.0.0 netmask 255.255.255.0 gw 10.0.0.1
iptables --flush && iptables --table nat --flush && iptables --table nat --flush && iptables --table nat --delete-chain &

echo 1 > /proc/sys/net/ipv4/ip_forward
#iptables -t nat -A PREROUTING -p udp -j DNAT --to 192.168.1.1
iptables -P FORWARD ACCEPT
iptables --append FORWARD --in-interface at0 -j ACCEPT
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
#iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
dhcpd -cf /etc/dhcp/dhcpd.conf -pf /var/run/dhcpd.pid at0
sleep 2
/etc/init.d/isc-dhcp-server start &
