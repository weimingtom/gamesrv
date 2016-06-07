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
	--os.execute("rm -rf " .. filename)
	os.remove(filename)

	 
	for i,line in ipairs(lines) do
		local tbl = {pcall(oscmd.docmd,line)}
		local pcall_ok = table.remove(tbl,1)
		local issuccess = table.remove(tbl,1)
		local result
		if next(tbl) then
			for j,v in ipairs(tbl) do
				tbl[i] = mytostring(v)
			end
			result = table.concat(tbl,",")
		end
		logger.log("info","oscmd",format("[oscmd.ontimer] docmd='%s' pcall_ok=%s issuccess=%s return=%s",line,pcall_ok,issuccess,result))
	end
end

function oscmd.docmd(line)
	local cmd,leftcmd = string.match(line,"^([%w_]+)%s+(.*)$")
	local args = {}	
	for arg in string.gmatch(leftcmd,"([^%s]+)") do
		table.insert(args,arg)
	end
	if cmd == "hotfix" then
		return hotfix.hotfix(leftcmd)
	elseif cmd == "gm" then
		local pid,leftcmd = string.match(leftcmd,"^([%d]+)%s+(.*)$")
		pid = tonumber(pid)
		if not pid then
			logger.log("info","oscmd",format("docmd='%s' no pid",line))
			return
		end
		return gm.docmd(pid,leftcmd)
	end
end

return oscmd
