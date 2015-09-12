local patten = skynet.getenv("script")
local ignore_module = {
	["script.agent"] = true,
	["script.watchdog"] = true,
}

print("chunk()",hotfix)
local srvname = skynet.getenv("srvname")
hotfix = hotfix or {}

function hotfix.hotfix(modname)
	if modname:sub(1,6) ~= "script" then
		logger.log("warning","hotfix",string.format("cann't hotfix non-script code,module=%s",modname))
		return
	end
	if modname:sub(-4,-1) == ".lua" then
		modname = modname:sub(1,-5)
	end
	if ignore_module[modname] then
		return
	end
	modname = string.gsub(modname,"/",".")
	modname = string.gsub(modname,"\\",".")
	skynet.cache.clear()
	local chunk,err
	local errlist = {}
	local env = _ENV
	env.__hotfix = nil
	local name = string.gsub(modname,"%.","/")
	local match_pat
	for pat in string.gmatch(patten,"[^;]+") do
		local filename = string.gsub(pat,"?",name)
		chunk,err = loadfile(filename,"bt",env)
		if chunk then
			match_pat = pat
			break
		else
			table.insert(errlist,err)
		end
	end
	if not chunk then
		local msg = string.format("hotfix fail,module=%s reason=%s",modname,table.concat(errlist,"\n"))
		logger.log("error","hotfix",msg)
		skynet.error(msg)
		return
	end
	local oldmod = package.loaded[modname]
	local newmod = chunk()
	package.loaded[modname] = newmod
	if type(env.__hotfix) == "function" then
		env.__hotfix(oldmod)
	end
	logger.log("info","hotfix",srvname .. " hotfix " .. modname)
	print (srvname,"hotfix " .. modname,oldmod,newmod,skynet.self())
end
return hotfix

