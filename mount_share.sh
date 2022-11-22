#!/bin/bash
echo "Montagem de partição externa" 

path_file="./0008541ecc15"
str_ip_mac=`cat $path_file`
path_ips="/home/tchelo/ips/"

IFS=';'
read -a ip_mac <<< "${str_ip_mac}"

ip1="${ip_mac[0]}"
mac1="${ip_mac[1]}"
#echo $ip1 $mac1

check_ip=`echo "${ip1}" | sed 's/[0-9\.]//g' | wc -c`
check_mac=`echo "${mac1}" | sed 's/[0-9a-z\:]//g' | wc -c`
#echo $check_ip $check_mac

len_ip="${#ip1}"
len_mac="${#mac1}"
#echo $len_ip $len_mac

if ! [[ $len_ip -ge 7 && $len_ip -le 15 && $check_ip -le 1 && $len_mac -eq 17 && $check_mac -le 1 ]];
then
	echo "Invalid IP or MAC"
	exit 1
fi

echo ""
hd2=`sudo mount -t nfs4 $ip1:/home/hd2.0 /home/tchelo/hd2.0`
if [ $? != 0 ]; 
then 
	echo -e "Ocorreu um erro ao montar hd2.0\n"
fi

hd750=`sudo mount -t nfs4 $ip1:/home/hd750 /home/tchelo/hd750`
if [ $? != 0 ]; 
then 
	echo -e "Ocorreu um erro ao montar hd750\n"
fi
