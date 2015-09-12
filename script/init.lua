require "script.game"

local srvname = skynet.getenv("srvname")
local c = srvlist[srvname]
local conf = {
	port = c.port,
	maxclient = c.maxclient,
	nodelay = true,
}

local function init()
	print("Server start",srvname)
	print("package.path:",package.path)
	print("package.cpath:",package.cpath)
	os.execute("pwd")
	skynet.register(".mainservice")
	--local console = skynet.newservice("console")
	--skynet.newservice("debug_console",8000)
	print("Watchdog listen on " .. conf.port)
	local watchdog = skynet.newservice("script/watchdog")
	skynet.call(watchdog,"lua","start",conf)
	-- script init
	game.startgame()	
end

skynet.start(init)
