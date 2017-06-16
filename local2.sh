#!/bin/bash
#set -e

#binlog文件接收目录
SqlFilePath="/data/test/"

#数据库用户
DBuser="root"

#数据库密码
DBpassword="li19950717"

#数据库名
DBname="myDatabase"

#进入接收同步目录并创建binlog同步目录
cd $SqlFilePath
mkdir -p /tmp/syncDBlogs

#将所有需要同步的binlog文件放在syncDBlogs下
files=$(ls *.binlog 2>/dev/null | wc -l)
if [ $files != '0' ]; then
    pwd
    mv *.binlog /tmp/syncDBlogs/
else 
    echo "没有可同步的binlog文件！"
    exit 1
fi

cd /tmp/syncDBlogs/
touch error.log

#对binlog文件进行同步操作
for logName in $( ls *.binlog|sort )
do
#mysql --user=$DBuser --password=$DBpassword $DBname < $logName >/dev/null 2>>error.log
mysqlbinlog --no-defaults logName | mysql --user=$DBuser --password=$DBpassword $DBname >/dev/null 2>>error.log
done

#同步检测，若同步完成则删除已同步的binlog文件
if [ $? -eq 0 ];then
rm -rf /tmp/syncDBlogs/
else 
    echo "同步错误，请检查错误！"
fi
