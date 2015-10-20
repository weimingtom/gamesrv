require "script.base.init"
require "script.conf.srvlist"
require "script.playermgr"
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
require "script.war.aux"
require "script.mail.mailmgr"
require "script.loginqueue"
require "script.huodong.huodongmgr"
require "script.object"
require "script.hotfix.init"
require "script.team.teammgr"
require "script.scene.scenemgr"

game = game or {}
function game.startgame()
	print("Startgame...")
	local fd = io.open("/dev/urandom","r")
	if fd then
		local d = fd:read(4)
		math.randomseed(os.time() + d:byte(1) + (d:byte(2) * 256) + (d:byte(3) * 65536) + (d:byte(4) * 4294967296))
	end
	console.init()
	logger.init()
	dbmgr.init()
	globalmgr.init()
	net.init()
	proto.init()
	playermgr.init()
	cluster.init()
	timectrl.init()
	gm.init()
	waraux.init()
	oscmd.init()
	loginqueue.init()
	mailmgr.init()
	scenemgr.init()
	cteammgr.startgame()
	huodongmgr.startgame()
	game.initall = true
	print("Startgame ok")
	logger.log("info","game","startgame")
end

function game.shutdown(reason)
	game.initall = nil
	print("Shutdown")
	logger.log("info","game",string.format("shutdown,reason=%s",reason))
	game.saveall()
	dbmgr.shutdown()
	logger.shutdown()
	skynet.sleep(2000) --20s
	os.execute(string.format("cd ../shell/ && sh killserver.sh %s",skynet.getenv("srvname")))
end

function game.saveall()
	logger.log("info","game","saveall")
	huodongmgr.savetodatabase()
	saveall()
end

return game
