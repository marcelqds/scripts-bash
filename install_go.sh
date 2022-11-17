#!/bin/bash
#https://go.dev/doc/install
#https://go.dev/dl/

url_down='https://go.dev/dl/go1.19.3.linux-amd64.tar.gz'
file_go=./godown.tar.gz
path_go=/usr/local
homesh=$HOME/.bashrc
up_go=$1

if [[ -e $file_go && $up_go  == '--update' || ! -e $file_go ]];
 then
 	rm -rf $file_go
 	echo "Efetuando download"
	down=`curl -Ls -o ./godown.tar.gz $url_down`
fi

echo "Instalando versão solicidata"
ins=`sudo rm -rf /usr/local/go && sudo tar -C /usr/local/ -zxf $file_go --index-file=/dev/null`

search=`echo $PATH | grep "/usr/local/go/bin"`

if [[ -e $homesh && $? == 1 ]]; 
then
	echo "Setando variáveis de ambiente"
	echo "export ENV_GO=${path_go}/go" >> $homesh
	echo "PATH="'$ENV_GO'/bin:'$PATH' >> $homesh
	source $homesh	
fi

echo -e "Versão atual do go\n"
go version
echo -e "\nInstalação concluída!\n"
