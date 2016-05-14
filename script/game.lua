require "script.skynet"
require "3rd.init"
require "script.base.init"
require "script.conf.srvlist"
require "script.playermgr"
require "script.playermgr.kuafu"
require "script.proto.init"
require "script.db.dbmgr"
require "script.timectrl.init"
require "script.logger.init"
require "script.net.init"
require "script.console.init"
require "script.gm.init"
require "script.oscmd.init"
require "script.globalmgr"
require "script.cluster.init"
require "script.cluster.route"
require "script.war.auxilary"
require "script.mail.mailmgr"
require "script.loginqueue"
require "script.huodong.huodongmgr"
require "script.object"
require "script.hotfix.init"
require "script.team.teammgr"
require "script.scene.scenemgr"
require "script.award.init"
require "script.formula.init"
require "script.event.init"
require "script.channel"

local function _print(...)
	print(...)
	skynet.error(...)
end

game = game or {}
function game.init()
	local fd = io.open("/dev/urandom","r")
	if fd then
		local d = fd:read(4)
		math.randomseed(os.time() + d:byte(1) + (d:byte(2) * 256) + (d:byte(3) * 65536) + (d:byte(4) * 4294967296))
		fd:close()
	end
	console.init()
	_print("console.init")
	logger.init()
	_print("logger.init")
	dbmgr.init()
	_print("dbmgr.init")
	globalmgr.init()
	_print("globalmgr.init")
	net.init()
	_print("net.init")
	proto.init()
	_print("proto.init")
	playermgr.init()
	_print("playermgr.init")
	cluster.init()
	_print("cluster.init")
	gm.init()
	_print("gm.init")
	waraux.init()
	_print("waraux.init")
	oscmd.init()
	_print("oscmd.init")
	loginqueue.init()
	_print("loginqueue.init")
	mailmgr.init()
	_print("mailmgr.init")
	scenemgr.init()
	_print("scenemgr.init")
	cteammgr.startgame()
	_print("cteammgr.startgame")
	huodongmgr.init()
	_print("huodongmgr.init")
	channel.init()
	_print("channel.init")
	event.init()
	_print("event.init")
	timectrl.init()
	_print("timectrl.init")
	game.initall = true
	game.startgame() -- 初始化完后启动的逻辑
	logger.log("info","game",string.format("[startgame] runno=%s",globalmgr.server:query("runno",0)))
end

function game.startgame()
	_print("Startgame...")
	cserver.starttimer_logstatus()
	_print("Startgame ok")
end

function game.shutdown(reason)
	game.initall = nil
	_print("Shutdown")
	logger.log("info","game",string.format("[shutdown start] reason=%s",reason))
	playermgr.kickall("shutdown")
	game.saveall()
	dbmgr.shutdown()
	timer.timeout("timer.shutdown",20,function ()

		logger.log("info","game",string.format("[shutdown success] reason=%s",reason))
		logger.shutdown()
		os.execute(string.format("cd ../shell/ && sh killserver.sh %s",skynet.getenv("srvname")))
	end)
end

function game.saveall()
	logger.log("info","game","[saveall]")

	--huodongmgr.savetodatabase()
	saveall()
end

return game
