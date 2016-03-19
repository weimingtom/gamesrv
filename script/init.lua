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
	skynet.register(".MAINSRV")
	--local console = skynet.newservice("console")
	skynet.newservice("debug_console",10000+c.port)
	print("Watchdog listen on " .. conf.port)
	local watchdog = skynet.newservice("script/watchdog")
	skynet.call(watchdog,"lua","start",conf)
	-- script init
	game.init()
end

skynet.start(init)
