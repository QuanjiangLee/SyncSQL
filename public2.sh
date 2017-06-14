#! /bin/bash
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

SqlFileSendPath="/data/test/"
#数据库用户
DBuser="root"

#数据库密码
DBpassword="li0717"

#数据库名
DBname="myDatabase"

mkdir -p /data/test/
mkdir -p /tmp/syncDBlogs
mkdir -p /tmp/exportLogs
#cp sqlOperate.py /tmp/exportLogs/

#刷新生成新的binlog日志文件
mysqladmin --user=$DBuser --password=$DBpassword flush-logs

if [ $? -eq 0 ];then
cd /var/log/mysql/
else echo "刷新日志失败！"
     exit 1
fi

files=$(ls mysql-bin.0* 2>/dev/null | wc -l)
if [ $files != '0' ]; then
    pwd
    cp mysql-bin.* /tmp/syncDBlogs
#rm -f mysql-bin.index
else 
    echo "没有bin-log文件！"
    exit 1
fi

#按照倒序逐个解压general log gz 文件
#for binName in $( ls mysql.log.*.gz|sort -r)
#do
#    gunzip -c $binName > /tmp/exportLogs/logs_`date +%s`.tmpsql;
#    sleep 1
#done

#按照先后顺序处理gerneral log,生成可执行sql文件



files=$(ls $SqlFileSendPath 2>/dev/null | wc -l)
if [ expr $file > 2 ]; then
echo "data文件大于零"
#for binName in $( ls mysql.log.*.gz|sort -r)
#do
fi
cd /tmp/syncDBlogs/
#rm *.index
files2=$(ls mysql-bin.0* 2>/dev/null | wc -l)
if [ $files2 != '0' ]; then
#保留log文件并转移到同步目录
cp * /tmp/exportLogs/ && mv /tmp/syncDBlogs/* $SqlFileSendPath
fi


#files2=$(ls *.tmpsql 2>/dev/null | wc -l)
#if [ $files2 != '0' ]; then
#for logName in $(ls *.tmpsql|sort )
#do
# python sqlOperate.py $logName
#echo "正在处理..."
# sleep 1
#done
#else echo "没有发现temsql文件！！" 
#     exit 1
#fi

#删除解压缩后的临时log文件
#rm -rf /tmp/exportLogs/*.
#删除已处理后的general log文件
#rm -rf /tmp/syncDBlogs
