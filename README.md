安装:
1. mkdir /home/game 或者 adduser game
2. mkdir /home/upload
3. cd /home/game/ && mkdir servers
4. cd /home/game/servers
5. 逻辑服
	git clone --recursive https://github.com/sundream/gamesrv.git gamesrv_100
	-- 如果shell、skynet子模块没有初始化，则执行以下操作，后续服务器的检出也类似，不再累述
	cd /home/game/servers/gamesrv_100
	git submodule init
	git submodule update
	如果git submodule update 失败，则重新初始化一遍子模块，如:
	rm -rf shell
	git rm -r shell
	git add https://github.com/sundream/shell.git shell

	rm -rf skynet
	git rm -r skynet
	git add https://github.com/sundream/skynet.git skynet

6. 中心节点服（方便做世界服、跨服好友哦，主要保存玩家简介信息）
	git clone --recursive https://github.com/sundream/gamesrv.git resumesrv

7. 账号中心
	git clone --recursive https://github.com/sundream/accountcenter.git accountcenter

8. 其他服（不是必须，跟业务逻辑有关）
	+第二个逻辑服：git clone --recursive https://github.com/sundream/gamesrv.git gamesrv_101
	+战斗管理服: git clone --recursive https://github.com/sundream/gamesrv.git warsrvmgr
	+战斗服：git clone --recursive https://github.com/sundream/gamesrv.git warsrv_1000

9. 客户端
	cd /home/game
	git clone --recursive https://github.com/sundream/client.git client
	-- -- 如果skynet子模块没有初始化，则执行以下操作，后续robert的检出也类似，不再累述
	cd /home/game/client
	git submodule init
	git submodule update
	如果git submodule update 失败，则重新初始化一遍子模块，如:
	rm -rf skynet
	git rm -r skynet
	git add https://github.com/sundream/skynet.git skynet

	git clone --recursive https://github.com/sundream/robert.git robert

启动
1. 启动服务器
	cd /home/game/servers/accountcenter/shell && sh startserver.sh
	cd /home/game/servers/resumesrv/shell && sh startserver.sh
	cd /home/game/servers/gamesrv_100/shell && sh startserver.sh


2. 启动客户端(客户端自带控制台，可以输入任何lua脚本控制)
	cd /home/game/client
	启动客户端：lua script/init 
	登陆游戏服gamesrv_100:
	login = require "script.test.test_login"
	login("gamesrv_100","lgl@sina.com","123")

3. 机器人压测
	cd /home/game/robert/skynet
	./skynet ../script/conf/robert.conf
	启动另一个shell,telnet连接控制机器人
	telent 127.0.0.1 6666
	start script/service/robertd 数量 起始角色ID
	如: start script/service/robertd 10 10001  <=> 从10001角色ID开始启动10个机器人连接gamesrv_100服务器


