cdb = cdb or {}

function cdb.new(conf)
	local self = {}
	self.conn = cdb:connect(conf)
	setmetatable(self,{__index = function (t,k)
		if cdb[k] then
			return cdb[k]
		end
		if t.conn[k] then
			return t.conn[k]
		end
	end})
	return self
end

function cdb:connect(conf)
	local conn = redis.connect(conf)	
	logger.log("info","db",format("connect to database:%s conn:%s",conf,tostring(conn)))
	return conn
end

function cdb:disconnect()
	logger.log("info","db",format("disconnect %s",tostring(self.conn)))
	self.conn:disconnect()
	self.conn = nil
end


function cdb:key(...)
	local args = {...}
	local ret = args[1] -- tblname
	for i = 2,#args do
		ret = ret .. ":" .. tostring(args[i])
	end
	return ret
end

function cdb:get(key,default)
	local value = self.conn:get(key)
	logger.log("debug","db",format("get,key=%s value=%s",key,value))
	if value then
		value = cjson.decode(value)
	else
		value = default
	end
	return value
end

function cdb:set(key,value)
	logger.log("debug","db",format("set,key=%s value=%s",key,value))
	value = cjson.encode(value)
	return self.conn:set(key,value)
end


function cdb:hset(key,field,value)
	value = cjson.encode(value)	
	self.conn:hset(key,field,value)
end

function cdb:hvals(key)
	local r = self.conn:hvals(key)
	for k,v in pairs(r) do
		r[k] = cjson.decode(v)
	end
	return r
end

return cdb
