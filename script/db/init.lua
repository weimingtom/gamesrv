local redis = require "redis"
local cjson = require "cjson"

require "script.logger"
cjson.encode_sparse_array(true)

db = db or {}

local conf = {
	host = "127.0.0.1",
	port = 6800,
	auth = "sundream",
	db = 0,
}

function db:connect(conf)
	local skynet = require "skynet"
	local srvname = conf.srvname or skynet.getenv("srvname")
	require "script.conf.srvlist"
	local srv = srvlist[srvname]
	conf.db = srv.db or 0
	self.conn = redis.connect(conf)	
	print(format("connect to database:%s,conn:%s",conf,tostring(self.conn)))
	return self.conn
end

function db:disconnect()
	self.conn:disconnect()
	self.conn = nil
end


function db:key(...)
	local args = {...}
	local ret = args[1] -- tblname
	for i = 2,#args do
		ret = ret .. ":" .. tostring(args[i])
	end
	return ret
end

function db:get(key,default)
	local value = self.conn:get(key)
	logger.log("debug","db",format("get,key=%s value=%s",key,value))
	if value then
		value = cjson.decode(value)
	else
		value = default
	end
	return value
end

function db:set(key,value)
	logger.log("debug","db",format("set,key=%s value=%s",key,value))
	value = cjson.encode(value)
	return self.conn:set(key,value)
end


function db:hset(key,field,value)
	value = cjson.encode(value)	
	self.conn:hset(key,field,value)
end

function db:hvals(key)
	local r = self.conn:hvals(key)
	for k,v in pairs(r) do
		r[k] = cjson.decode(v)
	end
	return r
end

function db.init()
	if db.conn then
		print "Already init"
		return
	end
	db.conn = db:connect(conf)
	setmetatable(db,{__index = db.conn,})
end

function db.shutdown()
	db:disconnect()
end

return db
