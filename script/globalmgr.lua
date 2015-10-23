require "script.server"
globalmgr = globalmgr or {}

function globalmgr.init()
	local server = cserver.new()
	server:loadfromdatabase()
	server:add("runno",1)
	globalmgr.server = server
end

return globalmgr
