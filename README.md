## 准备
```
1. 目录结构
	+ mkdir /home/game 或者 adduser game
	+ mkdir /home/upload
	+ cd /home/game/ && mkdir servers
	+ cd /home/game/servers && mkdir -p ds/gamesrv_100/data

2. [redis](http://redis.io/download)
	cd /home/game/servers/ds
	wget http://download.redis.io/releases/redis-3.0.5.tar.gz
	tar xzf redis-3.0.5.tar.gz
	cd redis-3.0.5
	make
3. [skynet](https://github/cloudwu/skynet.git)
	假定skynet安装目录为ROOT_SKYNET
	cd ROOT_SKYNET
	make clean
	make linux / make macosx(对于苹果)
```
## 安装
```
1. 逻辑服
	cd /home/game/servers
	git clone --recursive https://github.com/sundream/gamesrv.git gamesrv_100
	-- 如果shell、skynet子模块没有初始化，则执行以下操作，后续服务器的检出也类似，不再累述
	cd /home/game/servers/gamesrv_100
	git submodule init
	git submodule update
	
	修改配置文件:
	cd /home/game/servers/gamesrv_100
	cp script/conf/template/gamesrv.conf script/conf/gamesrv_100.conf
	将配置文件中的srvname字段改成：srvname = "gamesrv_100"
	
	-- 编译引入的第三方库，后续初始化服务器也类似，不再累述
	cd /home/game/servers/gamesrv_100/3rd && make clean && make all

2. 中心节点服/数据中心（方便做世界服、跨服好友哦，主要保存玩家简介信息）
	cd /home/game/servers
	git clone --recursive https://github.com/sundream/gamesrv.git datacenter
	
	修改配置文件:
	cd /home/game/servers/datacenter
	cp script/conf/template/datacenter.conf script/conf/datacenter.conf
	将配置文件中的srvname字段改成：srvname = "datacenter"

3. 账号中心
	cd /home/game/servers
	git clone --recursive https://github.com/sundream/accountcenter.git accountcenter
	
	修改配置文件:
	cd /home/game/servers/accountcenter
	cp script/conf/template/accountcenter.conf script/conf/accountcenter.conf
	将配置文件中的srvname字段改成：srvname = "accountcenter"

4. 其他服（不是必须，跟业务逻辑有关）
	+ cd /home/game/servers
	+ 第二个逻辑服：git clone --recursive https://github.com/sundream/gamesrv.git gamesrv_101
	+ 战斗管理服: git clone --recursive https://github.com/sundream/gamesrv.git warsrvmgr
	+ 战斗服：git clone --recursive https://github.com/sundream/gamesrv.git warsrv_1000

5. 客户端
	cd /home/game
	git clone --recursive https://github.com/sundream/client.git client

6. 机器人
	cd /home/game
	git clone --recursive https://github.com/sundream/robert.git robert
```

## 启动服务器
```
cd $SERVER_ROOT/shell && sh startredis.sh
cd $SERVER_ROOT/shell && sh startserver.sh
如:
cd /home/game/servers/gamesrv_100/shell && sh startredis.sh
cd /home/game/servers/accountcenter/shell && sh startserver.sh
cd /home/game/servers/datacenter/shell && sh startserver.sh
cd /home/game/servers/gamesrv_100/shell && sh startserver.sh
```
## 关闭服务器
```
cd $SERVER_ROOT/shell && sh shutdown.sh
```

## 启动客户端
```
1. 启动客户端(客户端自带控制台，可以输入任何lua脚本控制)
	cd /home/game/client
	启动客户端：lua script/init 
	登陆游戏服gamesrv_100:
	login = require "script.test.test_login"
	login("gamesrv_100","lgl@sina.com","123")

2. 机器人压测
	cd /home/game/robert/skynet
	./skynet ../script/conf/robert.conf
	启动另一个shell,telnet连接控制机器人
	telnet 127.0.0.1 6666
	start script/service/robertd 数量 起始角色ID
	如: start script/service/robertd 10 10001  <=> 从10001角色ID开始启动10个机器人连接gamesrv_100服务器
```

