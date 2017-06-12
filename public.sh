#! /bin/bash
#PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
#export PATH

SqlFileSendPath="/data/test/"
mkdir -p /data/test/
mkdir -p /tmp/syncDBlogs
mkdir -p /tmp/exportLogs

cd /var/log/mysql/
files=$(ls mysql.log.*.gz 2>/dev/null | wc -l)
if [ $files != '0' ]; then
    pwd
    mv mysql.log.*.gz /tmp/syncDBlogs
#rm -f mysql-bin.index
else 
    echo "没有gz文件！"
    exit 1
fi

cd /tmp/syncDBlogs/
#按照倒序逐个解压general log gz 文件
for binName in $( ls mysql.log.*.gz|sort -r)
do
    gunzip -c $binName > /tmp/exportLogs/logs_`date +%s`.tmpsql;
    sleep 1
done

#按照先后顺序处理gerneral log,生成可执行sql文件
cd /tmp/exportLogs
files2=$(ls *.tmpsql 2>/dev/null | wc -l)
if [ $files2 != '0' ]; then
for logName in $(ls *.tmpsql|sort )
do
 python sqlOperate.py $logName
echo "正在处理..."
 sleep 1
done
else echo "没有发现temsql文件！！" 
     exit 1
fi

#删除解压缩后的临时log文件
rm -rf /tmp/exportLogs/*.tmpsql
mv /tmp/exportLogs/*.log $SqlFileSendPath
#删除已处理后的general log文件
#rm -rf /tmp/syncDBlogs
