dbmgr = dbmgr or {}

function dbmgr.init()
	dbmgr.conns = {}
end

function dbmgr.getdb(srvname)
	if tonumber(srvname) then -- pid
		srvname = cserver.getsrvname(srvname)
	end
	srvname = srvname or cserver.srvname
	local conn = dbmgr.conns[srvname]
	if not conn then
		local srv = assert(srvlist[srvname])
		
		local conf = deepcopy(srv.db)
		conf.auth = conf.auth or "sundream"
		require "script.db.init"
		conn = cdb.new(conf)
		dbmgr.conns[srvname] = conn
	end
	return conn
end


function dbmgr.shutdown()
	for srvname,conn in pairs(dbmgr.conns) do
		conn:disconnect()
	end
end

return dbmgr
