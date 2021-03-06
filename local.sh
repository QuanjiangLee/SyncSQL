#!/bin/bash
#set -e
#sql文件存放目录
SqlFilePath="/data/test/"

#数据库用户
DBuser="root"

#数据库密码
DBpassword="li19950717"
#数据库名
DBname="myDatabase"

cd $SqlFilePath
mkdir -p /tmp/syncDBlogs
files=$(ls *.sql 2>/dev/null | wc -l)
if [ $files != '0' ]; then
    pwd
    mv *.sql /tmp/syncDBlogs/
else 
    echo "没有可同步sql文件！"
    exit 1
fi
cd /tmp/syncDBlogs/
touch error.log

for logName in $( ls *.sql|sort )
do
mysql --user=$DBuser --password=$DBpassword --database=$DBname < $logName >/dev/null 2>>error.log
done

if [ $? -eq 0 ];then
rm -rf /tmp/syncDBlogs/
else 
    echo "同步错误，请检查错误！"
fi
