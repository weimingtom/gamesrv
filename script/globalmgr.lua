require "script.server"
require "script.vote.votemgr"

globalmgr = globalmgr or {}

function globalmgr.init()
	assert(not globalmgr.binit)
	globalmgr.binit = true
	server = cserver.new()
	server:loadfromdatabase()
	server:add("runno",1)
	globalmgr.server = server

	votemgr = cvotemgr.new()
	globalmgr.votemgr = votemgr
end

return globalmgr
