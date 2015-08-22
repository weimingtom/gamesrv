require "script.server"
globalmgr = globalmgr or {}

function globalmgr.init()
	local srvobj = cserver.new()
	srvobj:loadfromdatabase()
	globalmgr.srvobj = srvobj
end

function globalmgr.getserver()
	return globalmgr.srvobj
end

return globalmgr
