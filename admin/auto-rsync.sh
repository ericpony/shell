#!/bin/bash

remoteUser=
remoteHost=
remotePort=
remoteDir=

localUser=
localHost=
localPort=
localDir=

localKeyPath="/home/$localUser/.ssh/"$localUser"_id_rsa.pub"
remoteKeyPath="/home/$localUser/.ssh/id_rsa"
remoteKeyPubPath="/home/$localUser/.ssh/id_rsa.pub"

#確認local端是否可以自動登入, 若不行則處理
ssh -p $remotePort $remoteUser@$remoteHost -o PreferredAuthentications=publickey "exit"
if [ $? -eq 255 ]; then
    #判斷是否已經擁有本身的 key pair
    if [ -e $localKeyPath ]; then
        echo rsa key exists
    else
        echo rsa key not exist
        ssh-keygen -t rsa
        #修改名稱成local端key pair
        mv ~/.ssh/id_rsa ~/.ssh/$localUser"_id_rsa"
        mv ~/.ssh/id_rsa.pub ~/.ssh/$localUser"_id_rsa.pub"
    fi

    #傳送金鑰至 remote 端, 並啟用
    scp ~/.ssh/$localUser"_id_rsa.pub" $remoteUser@$remoteHost:~/.ssh/.
    ssh -p $remotePort $remoteUser@$remoteHost "cat ~/.ssh/$localUser\"_id_rsa.pub\" >> ~/.ssh/authorized_keys ; chmod 711 ~/.ssh ; chmod 644 ~/.ssh/authorized_keys ; rm /home/$remoteUser/.ssh/$localUser\"_id_rsa.pub\""

    eval `ssh-agent -s`
    ssh-add
fi

rsync -avz -e ssh -p $remotePort $remoteUser@$remoteHost:$remoteDir $localDir
