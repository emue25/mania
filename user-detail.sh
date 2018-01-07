#!/bin/bash
# Created by

if [ "$1" = "" ]
then
        echo
        echo "Cara menggunakan: $0 Username"
        echo "Contoh:  $0 budi"
        echo
        exit 1
fi

Username=`cat /etc/passwd | grep -Ew ^$1 | cut -d":" -f1`

if [ "$Username" = "" ]
then
        echo "Username $1 Tidak dapat ditemukan"
        exit 2
fi

Userid=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f3`
UserPrimaryGroupId=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f4`
UserPrimaryGroup=`cat /etc/group | grep :"$UserPrimaryGroupId": | cut -d":" -f1`
UserInfo=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f5`
UserHomeDir=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f6`
UserShell=`cat /etc/passwd | grep -Ew ^$Username | cut -d":" -f7`
UserGroups=`groups $Username | awk -F": " '{print $2}'`
PasswordExpiryDate=`chage -l $Username | grep "Password expires" | awk -F": " '{print $2}'`
LastPasswordChangeDate=`chage -l $Username | grep "Last password change" | awk -F": " '{print $2}'`
AccountExpiryDate=`chage -l $Username | grep "Account expires" | awk -F": " '{print $2}'`
HomeDirSize=`du -hs $UserHomeDir | awk '{print $1}'`
clear
echo
  echo "Script by seller.Vps"
  echo "Terimakasih sudah berlangganan di seller.vps"
  echo " "
  echo "Detail Account untuk username $Username"
  echo "---------------------------------------"
printf "%-25s : %5s  [User Id - %s]\n" "Username                 " "$Username" "$Userid"
printf "%-25s : %5s\n"                 "Password terakhir diganti" "$LastPasswordChangeDate"
printf "%-25s : %5s\n"                 "Account Expired Pada     " "$AccountExpiryDate"
  echo "--------------------------------------"
  echo " "

