#/bin/bash

main() {
    echo ">>>>>>>> 此脚本用于 Linux 系统，请确认系统的正确，如果确认则忽略本提示。"
    echo ">>>>>>>> 输入期望部署的路径(输入 default 表示使用默认路径：~/.Wiki-WS): "
    read path 
    if [ $path == "default" ]
    then
        path="$HOME/.Wiki-WS" 
        echo ">>>>>>>> 部署路径设置为默认的：$path，如果部署出现异常请删除该目录，然后重新执行部署流程。"
    else
        echo ">>>>>>>> 部署路径设置为：$path，如果部署出现异常请删除该目录，然后重新执行部署流程。" 
    fi
    echo ">>>>>>>> 如果 $path/wiki-data 目录已经存在，请先将其删除" 
    mkdir -p $path/wiki-data 
    unzip -d $path/wiki-data wiki-data.zip
    prepareWiki 
    docker-compose -f $path/wiki-data/docker-compose.yml up -d
    echo ">>>>>>>> Wiki.js成功运行，数据存储于：$path/wiki-data，请妥善保管。"
}

prepareWiki() {
    echo ">>>>>>>> 删除已存在的Wiki.js"
    sudo docker stop heshixi-wiki-js-default-deploy && docker rm heshixi-wiki-js-default-deploy && docker stop heshixi-wiki-js-db-default-deploy && docker rm heshixi-wiki-js-db-default-deploy 
    echo ">>>>>>>> 开始加载Wiki.js"
    sudo docker load --input postgres.tar
    sudo docker load --input wiki.tar
    echo ">>>>>>>> 开始运行Wiki.js"
}

main