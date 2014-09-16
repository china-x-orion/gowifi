#/bin/bash!
sudo service hostapd stop
sudo ifconfig wlan0:0 10.10.0.254 netmask 255.255.255.0
sudo hostapd /etc/hostapd/hostapd.conf -B
sudo service isc-dhcp-server restart
sudo iptables -A FORWARD -i wlan0:0 -o wlan0 -s 10.10.0.0/25 -m state --state NEW -j ACCEPT
sudo iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -t nat -A POSTROUTING -o wlan0:0 -j MASQUERADE
sudo echo "1" >/proc/sys/net/ipv4/ip_forward
