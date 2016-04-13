dbmgr = dbmgr or {}

function dbmgr.init()
	dbmgr.conns = {}
end

function dbmgr.getdb(srvname)
	if srvname and tonumber(srvname) then -- pid
		srvname = cserver.getsrvname(srvname)
	end
	srvname = srvname or cserver.getsrvname()
	local conn = dbmgr.conns[srvname]
	if not conn then
		local conf
		if srvname == cserver.getsrvname() then
			conf = {
				host = skynet.getenv("dbip") or "127.0.0.1",
				port = tonumber(skynet.getenv("dbport")) or 6800,
				db = tonumber(skynet.getenv("dbno")) or 0,
				auth = skynet.getenv("dbauth") or "sundream",
			}
		else
			local srv = assert(srvlist[srvname])
			conf = deepcopy(srv.db)
			conf.auth = conf.auth or "sundream"
		end
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
