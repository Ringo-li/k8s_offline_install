#!/bin/bash
sed -i  /^PasswordAuthentication/s/no/yes/ /etc/ssh/sshd_config
systemctl restart sshd
echo "1">/proc/sys/net/ipv4/ip_forward
iptables -t nat -A PREROUTING -d 172.31.33.20 -p tcp --dport 443 -j DNAT --to 192.168.33.100:8443
iptables -t nat -A POSTROUTING -d 192.168.33.100 -p tcp --dport 8443 -j SNAT --to 192.168.33.20
iptables -t nat -A PREROUTING -d 172.31.33.20 -p tcp --dport 80 -j DNAT --to 192.168.33.100:8080
iptables -t nat -A POSTROUTING -d 192.168.33.100 -p tcp --dport 8080 -j SNAT --to 192.168.33.20
iptables -t nat -A PREROUTING -d 172.31.33.20 -p tcp --dport 22 -j DNAT --to 192.168.33.100:30331
iptables -t nat -A POSTROUTING -d 192.168.33.100 -p tcp --dport 30331 -j SNAT --to 192.168.33.20  -p tcp --dport 30331

iptables-save > /etc/sysconfig/iptables
echo "iptables-restore < /etc/sysconfig/iptables" >> /etc/rc.d/rc.local
chmod 755 /etc/rc.d/rc.local
