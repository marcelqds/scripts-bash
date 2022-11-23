#!/bin/bash
echo "Montagem de partição externa" 

path_ips="/home/tchelo/ips/dev"
#path_ips="./dev"

is_check=true
while $is_check
do
	str_ip_hostname=`cat $path_ips`		
	date_current=`date +"%Y%0m%0d"`
	pattern_check="^([0-9]{1,3}\.){3}[0-9]{1,3}\;[a-z0-9\-]{3,10}\;${date_current}$"
	check_values=`echo $str_ip_hostname | grep -icE $pattern_check`
	if [ $check_values -eq 1 ]; then is_check=false; else sleep 3; fi
done

IFS=';'
read -a ip_hostname <<< "${str_ip_hostname}"
ip1="${ip_hostname[0]}"
hostname1="${ip_hostname[1]}"

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
