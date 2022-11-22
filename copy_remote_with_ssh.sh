#!/bin/bash

echo "Get IP"
rede_local="192\.168\.1\.[0-9]{1,}"
remote="192\.168\.1\.107"
ip_remote="192.168.1.107"
name_save=$HOSTNAME
port_remote_pc=2022

if [[ $USER -eq "tchelo" ]]; then 
	path_user='/home/tchelo/.ssh/con_tchelo'
elif [[ $USER -eq "root" ]]; then
	path_user='/root/.ssh/con_root'
else 
	echo "User not permition"; exit 1
fi

is_not_ip=true
while $is_not_ip
do
	dt=`date +"%H:%M:$S"`
	ips=`ip a`
	echo  -e "${ips}\n\n" >> /home/tchelo/script/ipmac.log	
	
	ip1=`echo $ips | grep -oE "192\.168\.1\.([1-9][0-9]?|1[0-9]{2}|2[0-5][0-4])/" | tr -d "/"`
	echo "$dt :::> ${ip1}" >> /home/tchelo/script/ipmac.log	
	len_ip1=`echo $ip1 | wc -c`
	len_dots=`echo $ip1 | sed "s/[0-9\s]//g" | wc -c`
	len_num=`echo $ip1 | sed "s/\.//g" | wc -c`
	len_total=$(( len_dots + len_num - 1 ))
	echo ":: len_ip1=$len_ip1\nlen_dots=$len_dots\nlen_num=$len_num" >> /home/tchelo/script/ipmac.log
	
	if [ $len_ip1 -eq $len_total ] && [ $len_dots -eq 4 ] && [ $len_total -gt 10 ]; then 
		is_not_ip=false
		dt=`date +"%H:%M:$S"`
		echo "IP OK: $dt"
	else
		echo "Erro in ip formation try again"; 
		sleep 3
	fi	
done


is_check=true
while $is_check
do
	res_ping=`ping $ip_remote -c 1 | grep -cE "[0-9]+ bytes from ${remote}\:.+time\=.+"`	
	
	if [ $res_ping -eq 1 ]; then is_check=false
	else echo -e "Verify the computer: ${remote} is network connection"; sleep 1;
	fi
	
done

echo "Copy number ip to remote pc"
#name_save=`echo $mac1 | sed 's/://g'`

echo "$ip1;$name_save" | ssh -p $port_remote_pc -i $path_user tchelo@$ip_remote -T "touch ~/ips/${name_save} && cat > ~/ips/${name_save}"

if [ $? == 0 ];
then
	echo "Successful copy"
else
	echo "Error to copy"
fi
