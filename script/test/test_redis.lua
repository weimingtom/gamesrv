local cdb = cdb or {}

function cdb.new(conf)
	local self = {}
	self.dbsrv = skynet.newservice("script/service/redisd")
	setmetatable(self,{__index = function (t,k)
		local cmd = k
		local f = function (self,...)
			local func = cdb[cmd]
			if func then
				return func(self,...)
			else
				return skynet.call(self.dbsrv,"lua",cmd,...)
			end
		end
		t[k] = f
		return f
	end})
	if conf then
		self:connect(conf)
	end
	return self
end

function cdb:connect(conf)
	logger.log("info","db",format("connect to database:%s conn=%s",conf,self.dbsrv))
	skynet.call(self.dbsrv,"lua","connect",conf)
end

function cdb:disconnect()
	logger.log("info","db",format("disconnect %s",tostring(self.dbsrv)))
	skynet.call(self.dbsrv,"lua","disconnect")
	self.dbsrv = nil
end


function cdb:key(...)
	local args = {...}
	local ret = args[1] -- tblname
	for i = 2,#args do
		ret = ret .. ":" .. tostring(args[i])
	end
	return ret
end

function cdb:get(key)
	local value = skynet.call(self.dbsrv,"lua","get",key)
	logger.log("debug","db",format("get,key=%s value=%s",key,value))
	if value then
		value = cjson.decode(value)
	end
	return value
end

function cdb:set(key,value)
	assert(value~=nil)
	logger.log("debug","db",format("set,key=%s value=%s",key,value))
	value = cjson.encode(value)
	return skynet.call(self.dbsrv,"lua","set",key,value)
end


function cdb:hset(key,field,value)
	value = cjson.encode(value)	
	return skynet.call(self.dbsrv,"lua","hset",key,field,value)
end

function cdb:hvals(key)
	local r = skynet.call(self.dbsrv,"lua","hvals",key)
	for k,v in pairs(r) do
		r[k] = cjson.decode(v)
	end
	return r
end

local function main()
	local conf = {
		host = "127.0.0.1",
		port = 6800,
		db = 15,
		auth = "sundream",
	}
	local conn = cdb.new(conf)
	print(conn:set(conn:key("key",1),1))
	print(conn:get(conn:key("key",1)))
	print(conn:hset(conn:key("hkey",1),"one",1))
	print(conn:hget(conn:key("hkey",1),"one"))
	if conn:exists(conn:key("list",1)) then
		conn:del(conn:key("list",1))
	end
	print(conn:rpush(conn:key("list",1),1))
	print(conn:rpush(conn:key("list",1),2))
	local list = conn:lrange(conn:key("list",1),0,-1)
	for i,v in ipairs(list) do
		print(i,v)
	end
	conn:disconnect()
end

skynet.start(function ()
	main()
	print("second")
	main()
end)
return cdb
