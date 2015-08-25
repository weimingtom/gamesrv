require "script.base"
require "script.playermgr"
require "script.proto"
require "script.db"
require "script.timectrl"
require "script.logger"
require "script.net"
require "script.console"
require "script.gm"
require "script.oscmd"
require "script.globalmgr"
require "script.cluster"
require "script.war.aux"
require "script.mail.mailmgr"
require "script.loginqueue"
require "script.huodong.huodongmgr"

game = game or {}
function game.startgame()
	print("Startgame...")
	console.init()
	logger.init()
	db.init()
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
	db.shutdown()
	skynet.sleep(2000) --20s
	os.execute(string.format("cd ../shell/ && sh killserver.sh %s",skynet.getenv("srvname")))
end

function game.saveall()
	logger.log("info","game","saveall")
	saveall()
	huodongmgr.savetodatabase()	
end

return game
