#!/bin/bash
clear

# get the VPS IP
#ip=`ifconfig venet0:0 | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
if [ "$MYIP" = "" ]; then
	MYIP=$(wget -qO- ipv4.icanhazip.com)
fi
#myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;

flag=0

echo

	#MYIP=$(ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1)
	#if [ "$MYIP" = "" ]; then
		#MYIP=$(wget -qO- ipv4.icanhazip.com)
	#fi

	clear

	echo "--------------- WELCOME TO SERVER - IP:$MYIP ---------------"
	echo ""
	echo ""
	echo -e "\e[031;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m"
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

	echo -e "\e[096;1mCPU model:\e[0m $cname"
	echo -e "\e[096;1mNumber of cores:\e[0m $cores"
	echo -e "\e[096;1mCPU frequency:\e[0m $freq MHz"
	echo -e "\e[096;1mTotal amount of ram:\e[0m $tram MB"
	echo -e "\e[096;1mTotal amount of swap:\e[0m $swap MB"
	echo -e "\e[096;1mSystem uptime:\e[0m $up"
echo "                           Server: $MYIP"
date +"                           %A, %d-%m-%Y" 
date +"                                   %H:%M:%S %Z" 
        echo ""
	    echo "=======================================" 
        echo "Apa yang ingin anda lakukan?" 
		echo -e "\e[031;1m21\e[0m) Merubah Jam Restar Atau Auto Reboot VPS" 
		echo -e "\e[031;1m22\e[0m) URL Halaman Webmin VPS" 		
		echo -e "\e[031;1m23\e[0m) bench-network" 
		echo -e "\e[031;1m24\e[0m) Download Config OpenVPN" 
		echo -e "\e[031;1m25\e[0m) Merubah Password VPS ( root )" 
		echo -e "\e[031;1m26\e[0m) Merubah All  Port " 
		echo -e "\e[031;1m27\e[0m) TAMBAH IP YANG DI LOCK " 
		echo -e "\e[031;1m28\e[0m) Edit banner Login ssh" 
		echo -e "\e[031;1m29\e[0m) Bersihkan Cache Ram Manual" 
		echo -e "\e[031;1m30\e[0m) Lihat Lokasi User" 
        echo -e "\e[031;1m31\e[0m) Edit Banner Menu" 
		echo -e "\e[031;1m32\e[0m) (ON) Auto Kill Multi Login" 
        echo -e "\e[031;1m33\e[0m) (OFF) Auto Kill Multi Login" 
		echo -e "\e[031;1m34\e[0m) Restart Server VPS" 
		echo -e "\e[031;1m35\e[0m) Restart Dropbear " 
		echo -e "\e[031;1m36\e[0m) Restart Squid3" 
		echo -e "\e[031;1m37\e[0m) Restart OpenSSH" 
		echo -e "\e[031;1m38\e[0m) Update script" 
		echo ""
	    echo -e "\e[031;1m98\e[0m) Menu Utama   \e[031;1m x\e[0m) Exit" 
	    echo ""
		read -p "Ketik angka sesuai pilihan, Dan tekan tombol ENTER: " option
    case $option in
        21)
		  clear
          auto-reboot
		  exit
           ;;
        22)
		    clear
			echo "-------------------URL WEBMIN------------------------" 
			echo ""
			echo "Halaman Webmin $MYIP:10000" 
			echo ""
			echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------"
            exit
            ;;			
        23)
            clear
			echo "------------------- Bench-Network-------------------" 
			echo ""
			echo "BENCHMARK" 
	        bench-network 
			echo ""
			echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 
			exit
            ;;
        24)
            clear
			echo "---------------- URL CONFIG OpenVPN -----------------" 
			echo ""
			echo "Download Config $MYIP:85/client.ovpn" 
			echo ""
			echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 
			exit
            ;;
        25)
            clear
			echo "---------------MERUBAH PASSWORD ROOT-----------------" 
			echo ""
			read -p "Silahkan isi password baru untuk VPS anda: " pass	
            echo "root:$pass" | chpasswd
	        echo "Congratulations you've successfully changed the password VPS ,,Good luck...!!!"
			echo ""
			echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 	   
			exit
            ;;
        26)
            clear
			echo "---------------MERUBAH PORT-----------------" 
			echo ""
			rubah-port
			echo ""
			echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------"  		   
			exit
            ;;
        27)
            clear
			echo "---------------EDIT DAFTAR IP-----------------" 
			echo ""
            echo "--------------------------------------------------------" 
	        echo -e "1. Simpan text (CTRL + X, lalu ketik Y dan tekan ENTER)" 
	        echo -e "2. Membatalkan edit text (CTRL + X,lalu ketik N dan tekan ENTER)"
	        echo "--------------------------------------------------------" 
	        read -p "Tekan ENTER untuk melanjutkan..................." 
            nano /home/vps/public_html/arifssh/iplist.txt
            echo ""
			echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 	   
			exit
            ;;
        28)
            clear
			echo "---------------MERUBAH BANNER-----------------"
			echo ""
            echo -e "1.) Simpan text (CTRL + X, lalu ketik Y dan tekan Enter) "  
        	echo -e "2.) Membatalkan edit text (CTRL + X, lalu ketik N dan tekan Enter)"  
        	echo "-----------------------------------------------------------"  
        	read -p "Tekan ENTER untuk melanjutkan........................ "  
	        nano /bannerssh
	        service dropbear restart && service ssh restart
			echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSH/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 	   
			exit
            ;;
        29)
            clear
            echo "---------------Bersihkan Cache Ram Manual-----------------" 
			echo ""
            echo "Sebelum..." 
            free -h
	        echo 1 > /proc/sys/vm/drop_caches
	        sleep 1
	        echo 2 > /proc/sys/vm/drop_caches
	        sleep 1
	        echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a
	        sleep 1
	        echo ""
	        echo "Sesudah..." 
	        free -h
	        echo "Congratulations you've successfully Clear cache ram." 
            echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ALIYA HAURA/seller.vps.net\e[0m" 
            echo "-----------------------------------------------------" 
			exit
            ;;
        30)
           clear
           echo "---------------LOKASI USER-----------------" 
		   echo ""
           user-login
	       echo "Contoh: 49.0.35.16 lalu Enter" 
           read -p "Ketik Salah Satu Alamat IP User: " userip
           curl ipinfo.io/$userip
	       echo "-----------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSH/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 
			exit
            ;;
        31)
            clear
            echo "---------------EDIT BANNER MENU-----------------" 
			echo ""
            echo "--------------------------------------------------------" 
	        echo -e "1. Simpan text (CTRL + X, lalu ketik Y dan tekan ENTER)" 
	        echo -e "2. Membatalkan edit text (CTRL + X,lalu ketik N dan tekan ENTER)"
	        echo "--------------------------------------------------------" 
	        read -p "Tekan ENTER untuk melanjutkan..................." 
	        nano /usr/bin/bannermenu		
            echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 
			exit
            ;;
        32)
            clear
            echo "---------------(ON) Auto Kill Multi Login-----------------" 
			echo ""
			read -p "Isikan Maximal User Login (1-2): " MULTILOGIN2
	       #echo "@reboot root /root/userlimit.sh" > /etc/cron.d/userlimitreboot
	        echo "* * * * * root /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit1
	        echo "* * * * * root sleep 10; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit2
            echo "* * * * * root sleep 20; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit3
            echo "* * * * * root sleep 30; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit4
            echo "* * * * * root sleep 40; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit5
            echo "* * * * * root sleep 50; /usr/bin/userlimit.sh $MULTILOGIN2" > /etc/cron.d/userlimit6
	       #echo "@reboot root /root/userlimitssh.sh" >> /etc/cron.d/userlimitreboot
	        echo "* * * * * root /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit1
	        echo "* * * * * root sleep 11; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit2
            echo "* * * * * root sleep 21; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit3
            echo "* * * * * root sleep 31; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit4
            echo "* * * * * root sleep 41; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit5
            echo "* * * * * root sleep 51; /usr/bin/userlimitssh.sh $MULTILOGIN2" >> /etc/cron.d/userlimit6
	    service cron restart
	    service ssh restart
	    service dropbear restart
	    echo "------------+ Congratulations you've managed auto kill multi login +--------------" 
	    
	echo "Damn you cheap!!! Your users are angry do not blame ane ya boss
Later do not forget to turn off the boss
Let user happy bs multilogin again .." 
            echo "-----------------------------------------------------" 
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 
			exit
            ;;
        33)
            clear
            echo "---------------(OFF) Auto Kill Multi Login-----------------" 
			echo ""
			rm -rf /etc/cron.d/userlimit1
         	rm -rf /etc/cron.d/userlimit2
	        rm -rf /etc/cron.d/userlimit3
	        rm -rf /etc/cron.d/userlimit4
	        rm -rf /etc/cron.d/userlimit5
	        rm -rf /etc/cron.d/userlimit6
	        rm -rf /etc/cron.d/userlimitreboot
    	service cron restart
	    service ssh restart
	    service dropbear restart
	    clear
	    echo "AUTO KILL LOGIN, I HAVE STOPED BOS
Users Can Have Multi Log Again !!!!!!" 
            echo "-----------------------------------------------------"
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 
			exit
            ;;
        34)
            clear
            reboot
	        echo "sudah di restart waiting. . . . . .!!!" 
            exit
            ;;
        35)
            clear
            service dropbear restart
	        echo "Dropbear restart succes. . . .!!!" 
            exit
            ;;
        36)
            clear
            service squid3 restart
	        echo "Squid3 restart succes. . . .!!!" 
            exit
            ;;
        37)
            clear
			service ssh restart
	        echo "OpenSSH restart succes. . . .!!!" 
			exit
            ;;
         38)
            clear
			echo "---------------UPDATE SCRIPT-----------------" 
			echo ""
			read -p "Tekan ENTER untuk melanjutkan Update menu..................." 
			wget -O update.sh "https://raw.githubusercontent.com/brantbell/mania/centos6//update"
            chmod +x update
            ./update
            rm -f ./update
            echo "-----------------------------------------------------"
            echo -e "\e[032;1mScript Modified by ZHANGZI-SSL/seller.kimcil.net\e[0m" 
            echo "-----------------------------------------------------" 
			exit
            ;;
		98)
		    clear
			menu
		    exit
		    ;;			
		x)
		    clear
		    exit
		    ;;
	esac
done
