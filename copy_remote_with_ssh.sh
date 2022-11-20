echo "Obtendo ip"
rede_local="192\.168\.1\.[0-9]{1,}"
remote="192\.168\.1\.107"

ips=`ip a`
ip_and_mac=`echo $ips | grep -ihoE "link/eth.+(.{2}:.{2}:.{2}:.{2}:.{2}:.{2}).+inet\s?($rede_local)"`

count=0
for ip_mac in $ip_and_mac;
do
	if [ $count -eq 1 ];
	then
		echo $ip_mac
		mac1=$ip_mac
	elif [ $count -eq 5 ];
	then
		echo $ip_mac
		ip1=$ip_mac
	fi
	count=$((++count))
done

is_check=true
while $is_check
do
	res_ping=`ping 192.168.1.107 -c 1 | grep -cE "[0-9]+ bytes from ${remote}\:.+time\=.+"`	
	
	if [ $res_ping -eq 1 ]; then is_check=false
	else echo -e "Verifique da máquina: ${remote}"
	fi
	sleep 1	
done

echo "Copy number ip to remote pc"
name_save=`echo $mac1 | sed 's/://g'`
echo "$ip1;$mac1" | ssh -p 2022 -i $HOME/.ssh/con_tchelo tchelo@192.168.1.107 -T "touch ~/ips/${name_save} && cat > ~/ips/${name_save}"

if [ $? == 0 ];
then
	echo "Successful copy"
else
	echo "Error to copy"
fi
