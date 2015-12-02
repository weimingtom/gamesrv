


local function docmd(srvname,modname,cmd,...)
	modname = modname or ""
	if cmd[1] ~= "." or cmd[1] ~= ":" then
		cmd = "." .. cmd
	end
	if modname then
		cmd = string.format("return require('%s')%s",modname,cmd)
	end
	logger.log("debug","cluster",srvname,rpc,cmd,...)
	local chunk = load(cmd,"=(load)","bt",_G)
	local func = chunk()
	return func(...)
end

netcluster_rpc = netcluster_rpc or {}

function netcluster_rpc.dispatch(srvname,cmd,...)
	return docmd(srvname,cmd,...)
end

return netcluster_rpc
