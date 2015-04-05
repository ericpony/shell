#!/bin/bash

remoteUser=root
remoteHost=
remotePort=
remoteDir=/var/log/

localUser=
localHost=
localPort=
localDir=

listenPort=

localKeyPath="/home/$localUser/.ssh/"$localUser"_id_rsa.pub"
remoteKeyPath="/home/$localUser/.ssh/id_rsa"
remoteKeyPubPath="/home/$localUser/.ssh/id_rsa.pub"

# 確認 local 端是否可以自動登入, 若不行則進行處理
ssh -p $remotePort $remoteUser@$remoteHost -o PreferredAuthentications=publickey "exit"
if [ $? -eq 255 ]; then
    # 判斷是否已經擁有本身的 key pair
    if [ -e $localKeyPath ]; then
        echo rsa key exists
    else
        echo rsa key not exist
        ssh-keygen -t rsa
        # 修改名稱成 local 端 key pair
        mv ~/.ssh/id_rsa ~/.ssh/$localUser"_id_rsa"
        mv ~/.ssh/id_rsa.pub ~/.ssh/$localUser"_id_rsa.pub"
    fi

    # 傳送金鑰至 remote 端並啟用
    scp ~/.ssh/$localUser"_id_rsa.pub" $remoteUser@$remoteHost:~/.ssh/.
    ssh -p $remotePort $remoteUser@$remoteHost "cat ~/.ssh/$localUser\"_id_rsa.pub\" >> ~/.ssh/authorized_keys ; chmod 711 ~/.ssh ; chmod 644 ~/.ssh/authorized_keys ; rm /home/$remoteUser/.ssh/$localUser\"_id_rsa.pub\""

    eval `ssh-agent -s`
    ssh-add
fi

# 確認 local 端是否有 key pair 用於 remote 端自動連線
if [ -e $remoteKeyPath ]&&[ -e $remoteKeyPubPath ]; then
    echo key pair exists
else
    echo key pair not exist
    ssh-keygen -t rsa

    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    chmod 711 ~/.ssh
    chmod 644 ~/.ssh/authorized_keys
fi

# 確認 local 端是否有 key pair 用於 remote 端自動連線
if [ -e $remoteKeyPath ]&&[ -e $remoteKeyPubPath ]; then
    echo key pair exists
else
    echo key pair not exist
    ssh-keygen -t rsa

    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    chmod 711 ~/.ssh
    chmod 644 ~/.ssh/authorized_keys
fi

# 傳送私鑰給 remote 端後, 同步 log 並刪除其私鑰
scp ~/.ssh/id_rsa $remoteUser@$remoteHost:~/.ssh/.
ssh -p $remotePort -R $listenPort:$localHost:$localPort $remoteUser@$remoteHost "sudo rsync -avz -e \"ssh -p $localPort -i /home/$remoteUser/.ssh/id_rsa\" $remoteDir $localUser@$localHost:$localDir"
ssh $remoteUser@$remoteHost "rm /home/$remoteUser/.ssh/id_rsa"
