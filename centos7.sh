#!/bin/bash
# Created by https://www.hostingtermurah.net
# Modified by by kopet

#Requirement
if [ ! -e /usr/bin/curl ]; then
   yum -y update && yum -y upgrade
   yum -y install curl
fi

# initializing var
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# setting repo
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget http://rpms.remirepo.net/enterprise/remi-release-7.rpm
rpm -Uvh epel-release-latest-7.noarch.rpm
rpm -Uvh remi-release-7.rpm
wget http://repository.it4i.cz/mirrors/repoforge/redhat/el7/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
rpm -Uvh rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
sed -i 's/enabled = 1/enabled = 0/g' /etc/yum.repos.d/rpmforge.repo
sed -i -e "/^\[remi\]/,/^\[.*\]/ s|^\(enabled[ \t]*=[ \t]*0\\)|enabled=1|" /etc/yum.repos.d/remi.repo
rm -f *.rpm

# set time GMT +8
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime

# disable se linux
echo 0 > /selinux/enforce
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service sshd restart

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.d/rc.local

#Add DNS Server ipv4
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
sed -i '$ i\echo "nameserver 1.1.1.1" > /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 1.0.0.1" >> /etc/resolv.conf' /etc/rc.local
sed -i '$ i\echo "nameserver 1.1.1.1" > /etc/resolv.conf' /etc/rc.d/rc.local
sed -i '$ i\echo "nameserver 1.0.0.1" >> /etc/resolv.conf' /etc/rc.d/rc.local

# install wget and curl
yum -y install nano wget curl
yum -y install firewalld
systemctl start firewalld
systemctl enable firewalld

# install fail2ban
yum -y install fail2ban
service fail2ban restart
chkconfig fail2ban on

# install screenfetch
cd
wget -O /usr/bin/screenfetch "http://script.hostingtermurah.net/repo/screenfetch"
chmod +x /usr/bin/screenfetch
echo "clear" >> .bash_profile
echo "screenfetch" >> .bash_profile

cd
#wget "http://script.hostingtermurah.net/repo/webmin-1.801-1.noarch.rpm"
#yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty
wget "http://prdownloads.sourceforge.net/webadmin/webmin-1.930-1.noarch.rpm"
yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty perl-Encode-Detect
rpm -U webmin-1.930-1.noarch.rpm
#rpm -i webmin-1.801-1.noarch.rpm;
rm webmin-1.930-1.noarch.rpm
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart
chkconfig webmin on

# setting port ssh
sed -i '/Port 22/a Port 143' /etc/ssh/sshd_config
sed -i '/Port 22/a Port  90' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
service sshd restart
chkconfig sshd on

# install dropbear
yum -y install dropbear
echo "OPTIONS=\"-p 777 -p 110 -p 442\"" > /etc/sysconfig/dropbear
echo "/bin/false" >> /etc/shells
firewall-cmd --zone=public --add-port=777/tcp --permanent
firewall-cmd --zone=public --add-port=110/tcp --permanent
firewall-cmd --zone=public --add-port=442/tcp --permanent
firewall-cmd --reload
service dropbear restart
chkconfig dropbear on

#upgrade
yum -y install zlib1g-dev
wget https://raw.githubusercontent.com/emue25/VPSauto/master/dropbear-2019.78.tar.bz2
bzip2 -cd dropbear-2019.78.tar.bz2 | tar xvf -
cd dropbear-2019.78
./configure
make && make install

# install ddos deflate
cd
wget http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/grepcidr-2.0-1.el7.art.x86_64.rpm
rpm -Uvh grepcidr-2.0-1.el7.art.x86_64.rpm
yum install grepcidr
yum -y install dnsutils bind-utils dsniff unzip net-snmp net-snmp-utils tcpdump
wget https://github.com/jgmdev/ddos-deflate/archive/master.zip
unzip master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/master.zip
cd

# setting banner
rm /etc/issue.net -f
wget -O /etc/issue.net "https://raw.githubusercontent.com/emue25/mania/centos6/issue.net"
sed -i '/Banner/a Banner="/etc/issue.net"' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
systemctl restart sshd.service
systemctl restart dropbear.service

# install badvpn
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/shigeno143/OCSPanelCentos6/master/badvpn-udpgw64"
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.d/rc.local
chmod +x /usr/bin/badvpn-udpgw
yum install screen -y
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300
firewall-cmd --zone=public --add-port=7300/tcp --permanent
firewall-cmd --reload
#nginx
yum -y install nginx
rm /etc/nginx/sites-enabled/default
wget -O /etc/nginx/sites-enabled/default "http://evira.us/default"
ystemctl restart nginx.service

# install openvpn
yum -y install openvpn
wget -O /tmp/easyrsa https://github.com/OpenVPN/easy-rsa-old/archive/2.3.3.tar.gz
tar xfz /tmp/easyrsa
mkdir /etc/openvpn/easy-rsa
cp -rf easy-rsa-old-2.3.3/easy-rsa/2.0/* /etc/openvpn/easy-rsa
mkdir /etc/openvpn/easy-rsa/keys
sed -i 's/export PKCS11/#export PKCS11/g' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_CN/#export KEY_CN/g' /etc/openvpn/easy-rsa/vars
sed -i 's/export KEY_EMAIL=mail@host.domain/#export KEY_EMAIL=mail@host.domain/g' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_COUNTRY="US"|export KEY_COUNTRY="PH"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_PROVINCE="CA"|export KEY_PROVINCE="Manila"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_CITY="SanFrancisco"|export KEY_CITY="Sampaloc"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_ORG="Fort-Funston"|export KEY_ORG="TaCoMe"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_EMAIL="me@myhost.mydomain"|export KEY_EMAIL="smith.tacome@gmail.com"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_NAME=changeme|export KEY_NAME="server"|' /etc/openvpn/easy-rsa/vars
sed -i 's|export KEY_OU=changeme|export KEY_OU="TCMvpn"|' /etc/openvpn/easy-rsa/vars
#Create Diffie-Helman Pem
openssl dhparam -out /etc/openvpn/dh2048.pem 2048
# Create PKI
cd /etc/openvpn/easy-rsa
cp openssl-1.0.0.cnf openssl.cnf
. ./vars
./clean-all
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --initca $*
# create key server
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --server server
# setting KEY CN
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" client
cd
cd /etc/openvpn/easy-rsa/keys
cp ca.crt server.crt server.key /etc/openvpn
cd
# setting server
cat > /etc/openvpn/server.conf <<-END
port 443
proto tcp
dev tun
ca ca.crt
cert server.crt
key server.key 
dh dh2048.pem
client-cert-not-required
username-as-common-name
plugin /usr/lib64/openvpn/plugins/openvpn-plugin-auth-pam.so login
server 192.168.100.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
push "route-method exe"
push "route-delay 2"
duplicate-cn
push "route-method exe"
push "route-delay 2"
keepalive 10 120
persist-key
persist-tun
status openvpn-status.log
log openvpn.log
verb 3
cipher AES-256-CBC
END
cat > /etc/openvpn/server-udp.conf <<-END
port 53
proto udp
dev tun
tun-mtu 1500
tun-mtu-extra 32
mssfix 1450
ca ca.crt
cert server.crt
key server.key
dh dh2048.pem
plugin /etc/openvpn/openvpn-plugin-auth-pam.so /etc/pam.d/login
client-cert-not-required
username-as-common-name
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1"
push "dhcp-option DNS 1.1.1.1"
push "dhcp-option DNS 1.0.0.1"
push "route-method exe"
push "route-delay 2"
keepalive 5 30
cipher AES-128-CBC
comp-lzo
persist-key
persist-tun
status server-vpn.log
verb 3
cd

# create openvpn config
cat > openvpn.ovpn <<-END
#modified by kopet
client
dev tun
proto tcp
remote xxxxxxxxx 443
http-proxy xxxxxxxxx 80
persist-key
persist-tun
dev tun
pull
resolv-retry infinite
nobind
ns-cert-type server
verb 3
mute 2
mute-replay-warnings
auth-user-pass
setenv opt block-outside-dns
redirect-gateway def1
script-security 2
route 0.0.0.0 0.0.0.0
route-method exe
route-delay 2
cipher AES-256-CBC
setenv CLIENT_CERT 0
dhcp-option DOMAIN 1dot1dot1dot1.cloudflare-dns.com

END
echo '<ca>' >> openvpn.ovpn
cat /etc/openvpn/ca.crt >> openvpn.ovpn
echo '</ca>' >> openvpn.ovpn
sed -i $MYIP2 openvpn.ovpn;

#setup firewall
firewall-cmd --get-active-zones
firewall-cmd --zone=trusted --add-service openvpn
firewall-cmd --zone=trusted --add-service openvpn --permanent
firewall-cmd --list-services --zone=trusted
firewall-cmd --add-masquerade
firewall-cmd --permanent --add-masquerade
firewall-cmd --query-masquerade
SHARK=$(ip route get 1.1.1.1 | awk 'NR==1 {print $(NF-2)}')
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s 192.168.100.0/24 -o $SHARK -j MASQUERADE
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
#forward ipv4
sysctl -w net.ipv4.ip_forward=1
touch /usr/lib/sysctl.d/sysctl.conf
cat > /usr/lib/sysctl.d/sysctl.conf <<-END
net.ipv4.ip_forward = 1
END
systemctl restart network.service
systemctl -f enable openvpn@server.service
systemctl start openvpn@server.service
systemctl status openvpn@server.service
chkconfig openvpn on


##################squid3.1.23
cd

#dependencies
yum install -y binutils gcc-c++
yum install -y perl gcc autoconf automake make sudo wget
yum install -y libxml2-devel libcap-devel
yum install -y libtool-ltdl-devel
 
#Downloading Squid Source Archive
mkdir /usr/src/squid
cd /usr/src/squid
wget http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.23.tar.gz
tar fxvz squid-3.1.23.tar.gz
cd squid-3.1.23
 
#Compiling Squid Proxy
./configure --prefix=/usr --includedir=/usr/include --datadir=/usr/share --bindir=/usr/sbin --libexecdir=/usr/lib/squid --localstatedir=/var --sysconfdir=/etc/squid --enable-delay-pools --enable-arp-acl --enable-linux-netfilter && echo "Configuration Successful"
make clean
make -j4
make install
 
#create files for squid's default user nobody
touch /var/cache/squid
chown -R nobody:nobody /var/cache/squid
touch /var/logs/cache.log
chown nobody:nobody /var/logs/cache.log
touch /var/logs/access.log
chown -R nobody:nobody /var/logs/access.log
tail -f /var/logs/cache.log &
#Create missing swap directories and other missing cache_dir structures
/usr/sbin/squid -z
#start squid
/usr/sbin/squid
 
# add firewall rule to allow inbound port connections
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=3128/tcp --permanent
firewall-cmd --zone=public --add-port=8000/tcp --permanent
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=8888/tcp --permanent
firewall-cmd --reload
 
#Automatic starting Squid service on start-up using shell script
cat > /etc/rc.d/init.d/squid <<-END
#!/bin/bash
# init script to control Squid server
case "$1" in
start)
/usr/sbin/squid
;;
stop)
/usr/sbin/squid -k shutdown
;;
reload)
/usr/sbin/squid -k reconfigure
;;
restart)
/usr/sbin/squid -k shutdown
sleep 2
/usr/sbin/squid
;;
*)
echo $"Usage: $0 {start|stop|reload|restart}"
exit 2
esac
exit $?
END
 
#command to start squid service
echo /usr/sbin/squid >> /etc/rc.local
chmod +x /etc/rc.local
 
#modify squid.conf
cat > /etc/squid/squid.conf <<-END
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.0.0/16
acl localnet src fc00::/7
acl localnet src fe80::/10
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 21
acl Safe_ports port 443
acl Safe_ports port 70
acl Safe_ports port 210
acl Safe_ports port 1025-65535
acl Safe_ports port 280
acl Safe_ports port 488
acl Safe_ports port 591
acl Safe_ports port 777
acl CONNECT method CONNECT
acl SSH dst xxxxxxxxx-xxxxxxxxx/32
http_access allow SSH
http_access allow manager localhost
http_access deny manager
http_access allow localnet
http_access allow localhost
http_access deny all
http_port 8888
http_port 8080
http_port 8000
http_port 80
http_port 3128
hierarchy_stoplist cgi-bin ?
# Leave coredumps in the first cache dir
coredump_dir /var/cache
# Add any of your own refresh_pattern entries above these.
refresh_pattern ^ftp:       1440    20% 10080
refresh_pattern ^gopher:    1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern .       0   20% 4320
visible_hostname kopet
END
sed -i $MYIP2 /etc/squid/squid.conf;

cd
# download script
wget https://raw.githubusercontent.com/daybreakersx/premscript/master/install-premiumscript.sh -O - -o /dev/null|sh
#wget https://raw.githubusercontent.com/brantbell/cream/mei/install-premiumscript.sh -O - -o /dev/null|sh
#vix
wget https://raw.githubusercontent.com/emue25/mania/centos6/fix-centos-useradd.sh && chmod +x fix-centos-useradd.sh && ./fix-centos-useradd.sh

touch /root/log.txt
cat > /root/log.txt <<-END
"---------------------------Squid Commands---------------------------"
"           to start:    # /usr/sbin/squid                           "
"            to stop:    # /usr/sbin/squid -k shutdown               "
"          to reload:    # /usr/sbin/squid -k reconfigure            "
" to test if running:    # ps uax|grep squid                         "
"      to check logs:    # tail /var/logs/cache.log                  "
"--------------------------------------------------------------------"
"-------------------------OpenVPN Commands---------------------------"
"           to start:    # systemctl start openvpn@server.service    "
"            to stop:    # systemctl stop openvpn@server.service     "
"          to reload:    # systemctl restart openvpn@server.service  "
"    to check status:    # systemctl status openvpn@server.service   "
"--------------------------------------------------------------------"
"----------------------     Add Users     ---------------------------"
"             to add:    # useradd enterusernamehere                 "
"      change passwd:    # echo "username:password" | chpasswd       "
"          to remove:    # userdel username                          "
"--------------------------------------------------------------------"
Application & Port Information
   - OpenVPN     : TCP 443 
   - OpenSSH     : 22, 143, 90
   - Dropbear    : 109, 110, 442
   - Squid Proxy : 80, 8000, 8080, 8888, 3128 (limit to IP Server)
   - Badvpn      : 7300
Script Compiled By Tacome9 (https://www.phcorner.net/members/228541/)
END

#clearing history
history -c

# info
clear

echo " "
echo "INSTALLATION COMPLETE!"
echo " "
echo "---------------------------Squid Commands---------------------------"
echo "           to start:    # /usr/sbin/squid                           "
echo "            to stop:    # /usr/sbin/squid -k shutdown               "
echo "          to reload:    # /usr/sbin/squid -k reconfigure            "
echo " to test if running:    # ps uax|grep squid                         "
echo "      to check logs:    # tail /var/logs/cache.log                  "
echo "--------------------------------------------------------------------"
echo "-------------------------OpenVPN Commands---------------------------"
echo "           to start:    # systemctl start openvpn@server.service    "
echo "            to stop:    # systemctl stop openvpn@server.service     "
echo "          to reload:    # systemctl restart openvpn@server.service  "
echo "    to check status:    # systemctl status openvpn@server.service   "
echo "--------------------------------------------------------------------"
echo "----------------------     Add Users     ---------------------------"
echo "             to add:    # useradd enterusernamehere                 "
echo "      change passwd:    # echo "username:password" | chpasswd       "
echo "          to remove:    # userdel username                          "
echo "--------------------------------------------------------------------"
echo "Application & Port Information"
echo "   - OpenVPN     : TCP 443 "
echo "   - OpenSSH     : 22, 143, 90"
echo "   - Dropbear    : 109, 110, 442"
echo "   - Squid Proxy : 80, 8000, 8080, 8888, 3128 (limit to IP Server)" 
echo "   - Badvpn      : 7300"
echo " "
echo "----- Script Created By Steven Indarto(fb.com/stevenindarto2) ------"
echo " Modified By Tacome9 (https://www.phcorner.net/members/228541/)"
#restart squid
/usr/sbin/squid -k shutdown
/usr/sbin/squid

