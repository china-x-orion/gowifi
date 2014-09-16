#! /bin/bash

case $1 in
    "start")
       sleep 1
       ifconfig wlan0 192.168.10.1 netmask 255.255.255.0
       sleep 1
       echo "1" >/proc/sys/net/ipv4/ip_forward
       sleep 1
       iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
       sleep 1
       /etc/init.d/hostapd start
       sleep 1
       /etc/init.d/dnsmasq start
    ;;
    "stop")
       /etc/init.d/dnsmasq stop
       /etc/init.d/hostapd stop
       sleep 1
       iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
       sleep 1
       echo "0" >/proc/sys/net/ipv4/ip_forward
       sleep 1
    ;;
    *)
       echo "Usage $0 {start|stop}"
    ;;
    esac
