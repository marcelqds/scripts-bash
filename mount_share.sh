#!/bin/bash
echo "Montagem de partição externa" 

path_ips="/home/tchelo/ips/dev"

is_check=true
while $is_check
do
	str_ip_hostname=`cat $path_ips`

	IFS=';'
	read -a ip_hostname <<< "${str_ip_hostname}"
	
	ip1="${ip_hostname[0]}"
	hostname1="${ip_hostname[1]}"
	dt_check="${ip_hostname[2]}"
	dt=`date +"%Y%0m%0d"`
	
	len_hostname="${#hostname1}"
	check_ip=`echo $ip1 | grep -cE "([0-9]+\.){3}[0-9]+"`
	#echo -e "\nIp:$ip1 \nHostname:$hostname1 - length:$len_hostname\nDate send:$dt_check\nDate Actual:$dt"
		
	if [[ $len_hostname -gt 0 && $check_ip -eq 1 && $dt -eq $dt_check ]]; then 
		is_check=false		
	else
		sleep 3
	fi

done

base_path="/home/tchelo/"
hd2="${base_path}hd2.0"
hd750="${base_path}hd750"

`sudo umount -f -l $hd2`
`sudo umount -f -l $hd750`

echo ""
hd21=`sudo mount -t nfs4 $ip1:/home/hd2.0 $hd2`
if [ $? != 0 ]; 
then 
	echo -e "Ocorreu um erro ao montar hd2.0\n"
fi

hd7501=`sudo mount -t nfs4 $ip1:/home/hd750 $hd750`
if [ $? != 0 ]; 
then 
	echo -e "Ocorreu um erro ao montar hd750\n"
fi
