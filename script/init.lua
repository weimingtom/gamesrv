require "script.game"

local srvname = skynet.getenv("srvname")
local conf = {
	port = tonumber(skynet.getenv("port")),
	maxclient = tonumber(skynet.getenv("maxclient")),
	nodelay = true,
}

local function init()
	print("Server start",srvname)
	print("package.path:",package.path)
	print("package.cpath:",package.cpath)
	os.execute("pwd")
	skynet.register(".MAINSRV")
	--local console = skynet.newservice("console")
	skynet.newservice("debug_console",10000+conf.port)
	print("Watchdog listen on " .. conf.port)
	local watchdog = skynet.newservice("script/watchdog")
	skynet.call(watchdog,"lua","start",conf)
	-- script init
	game.init()
end

skynet.start(init)
