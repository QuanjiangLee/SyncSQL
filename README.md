# 以binlog为例同步数据库
## 主数据库脚本使用说明
* 开启主数据库binlog服务：
  在外网服务器的数据库配置文件中添加以下配置：
    server-id               = 1
    log_bir                 = /var/log/mysql/mysql-bin.log
    expire_logs_days        = 10
    max_binlog_size         = 10M
    binlog_format           = mixed
  然后使用systemctl restart mysql 重启数据库,此时ls /var/log/mysql/
  可查看到 mysql-bin.00000* 等文件则表示开启binlog成功。

* 对数据库进行增删改等测试操作。

* 设置单导发送同步路径和数据库信息
  打开public2.sh ,修改SqlFileSendPath的路径，如设置单导发送的同步路径为/data/test/,则SqlFileSendPath="/data/test/"
  类似的设置数据库用户DBuser，数据库密码DBpassword和数据库名DBname
  设置完成后保存退出。

* 运行主机同步脚本 sudo sh public2.sh 

注：public2.sh脚本作用是刷新当前binlog日志，将需要同步的binlog文件备份到/tmp/exportLogs/下和转移到单导发送同步目录。

## 从数据库脚本使用说明
* 设置单导接收路径和从数据库连接信息
  打开local2.sh,,修改SqlFileSendPath的路径，如设置接收路径为/data/test/,则SqlFileSendPath="/data/test/"
  类似的设置数据库用户DBuser，数据库密码DBpassword和数据库名DBname
  设置完成后保存退出。
* 运行从机数据库同步脚本 sudo sh local2.sh

注：local2.sh脚本的作用是检测接收同步路径下是否有可同步到数据库的binlog文件，若有，则进行binlog同步操作，并在同步完成后删除此路径下的binlog文件，若没有binlog文件可同步，则什么也不做。


