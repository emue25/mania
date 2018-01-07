#!/bin/bash

echo -e "------------------------ \e[032;1mTRIAL USER SSH\e[0m ------------------------"
echo -e "                       \e[032;1mALL SUPPORTED ZHANGZI-SSL\e[0m"
echo -e "                 \e[032;1mhttps://www.facebook.com/kopet88\e[0m"
echo -e "        \e[032;1mCONTACT SUPPORT Telegram @DENBAGUSS SMS/WA 60146309176\e[0m"

echo "Please Wait..."
sleep 0.5
echo "Generating Account..."
sleep 0.5
echo "Generating Host..."
sleep 0.5
echo "Generating Username..."
sleep 0.5
echo "Generating Password..."
sleep 1
MYIP=$(wget -qO- ipv4.icanhazip.com)
passrandom=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

username=trial
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
# proses mengganti passwordnya
  echo -e "$passrandom\n$passrandom" | passwd $username
  clear
  echo " "
  echo "Script by vps-murah.net"
  echo "Terimakasih sudah berlangganan di vps-murah.net"
  echo " "
  echo "Demikian Detail Account Trial Anda"
  echo "------------------------------"
  echo "   Host     : $MYIP" 
  echo "   Username : $username"
  echo "   Password : $passrandom"
  echo "   Dropbear Port: 443, 110, 80"
  echo "   SSL/TSL Port: 444"
  echo "   OpenSSH Port: 22, 143"
  echo "   Squid Proxy: 8000, 8080, 3128"
  echo "   OpenVPN Config: http://$MYIP:85/client.ovpn"
  echo "------------------------------"
  echo " "
  
else
  useradd trial
  usermod -s /bin/false trial
  egrep "^$username" /etc/passwd >/dev/null
  echo -e "$passrandom\n$passrandom" | passwd $username
  clear
  echo " "
  echo "Script by seller-vps.net"
  echo "Terimakasih sudah berlangganan di seller-vps"
  echo " "
  echo "Demikian Detail Account Trial Anda"
  echo "------------------------------"
  echo "   Host     : $MYIP"
  echo "   Username : $username"
  echo "   Password : $passrandom"
  echo "   Dropbear Port: 443, 110, 80"
  echo "   OpenSSH Port: 110, 143"
  echo "   SSL/TSL Port: 444"
  echo "   Squid Proxy: 8000, 8080, 3128"
  echo "   OpenVPN Config: http://$MYIP:85/client.ovpn"
  echo "------------------------------"
  echo " "
fi
