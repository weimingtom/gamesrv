oscmd = oscmd or {}
local delay = 10 --60
local filename = "../shell/.oscmd.txt"

function oscmd.init()
	logger.log("info","oscmd","init")
	timer.timeout("timer.oscmd",delay,oscmd.ontimer)
end

function oscmd.ontimer()
	timer.timeout("timer.oscmd",delay,oscmd.ontimer)
	local fd = io.open(filename,"rb")
	if not fd then
		return
	end
	local str = fd:read("*a")
	local lines = {}
	for line in string.gmatch(str,"[^\n]+") do
		lines[#lines+1]=line
	end
	fd:close()
	os.execute("rm -rf " .. filename)

	 
	for i,line in ipairs(lines) do
		local isok,result = pcall(oscmd.docmd,line)
		logger.log("info","oscmd",format("docmd='%s' isok=%s result=%s",line,isok,result))
	end
end

function oscmd.docmd(line)
	local cmd,leftcmd = string.match(line,"^([%w_]+)%s+(.*)$")
	local args = {}	
	for arg in string.gmatch(leftcmd,"([^%s]+)") do
		table.insert(args,arg)
	end
	if cmd == "hotfix" then
		hotfix.hotfix(leftcmd)
	elseif cmd == "gm" then
		pid,leftcmd = string.match(leftcmd,"^([%d]+)%s+(.*)$")
		pid = tonumber(pid)
		gm.docmd(pid,leftcmd)
	end
	return "success"
end

return oscmd
