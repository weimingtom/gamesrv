require "script.base.class"
require "script.base.netcache"

cdatabaseable = class("cdatabaseable")
local sep = "."

cdatabaseable.new = nil

function cdatabaseable:init(conf)
	self.pid = conf.pid
	self.__flag = conf.flag
	assert(self.pid,"no pid")
	assert(self.__flag,"no flag")
	self.dirty = false
end

function cdatabaseable:clear()
	self.dirty = false
	self.data = {}
end

function cdatabaseable:isdirty()
	return self.dirty
end

cdatabaseable.updated = cdatabaseable.isdirty

function cdatabaseable:update(action,key,oldval,newval)
	if oldval ~= newval then
		self.dirty = true
		if self.pid > 0 then
			netcache.update(self.pid,self.__flag,key,newval)
		end
		return true
	end
	return false
end

function cdatabaseable:basic_set(key,val)
	local oldval = self.data[key]
	self.data[key] = val
	self:update("set",key,oldval,val)
	return oldval
end

function cdatabaseable:basic_query(key,default)
	return self.data[key] or default
end

function cdatabaseable:basic_delete(key)
	local oldval = self.data[key]
	self.data[key] = nil
	self:update("delete",key,oldval,nil)
	return oldval
end

function cdatabaseable:basic_add(key,val)
	local oldval = self.data[key]
	self.data[key] = (self.data[key] or 0) + val
	self:update("add",key,oldval,self.data[key])
	return oldval
end

function cdatabaseable:last_key_mod(data,key)
	local lastmod = data
	local lastkey
	local start = 1
	local b,e = string.find(key,sep,start,true)
	while b do
		--print(b,e,start)
		lastkey = string.sub(key,start,b-1)
		assert(string.len(string.gsub(lastkey,"[ \t\n]","")) ~= 0,"occur white string")
		if lastmod[lastkey] then
			if type(lastmod[lastkey]) ~= "table" then
				return nil
			end
			lastmod = lastmod[lastkey]
		else
			lastmod[lastkey] = {}
			lastmod = lastmod[lastkey]
		end
		start = e + 1
		b,e = string.find(key,sep,start,true)
	end
	lastkey = string.sub(key,start)
	assert(string.len(string.gsub(lastkey,"[ \t\n]","")) ~= 0,"occur white string")
	return true,lastkey,lastmod
end

function cdatabaseable:set(key,val)
	local ok,lastkey,lastmod = self:last_key_mod(self.data,key)	
	if not ok then
		error(string.format("[cdatabaseable:set] exists same variable, pid=%d key=%s",self.pid,key))
	end
	local oldval = lastmod[lastkey]
	lastmod[lastkey] = val
	self:update("set",key,oldval,val)
	return oldval
end

function cdatabaseable:query(key,default)
	local ok,lastkey,lastmod = self:last_key_mod(self.data,key)
	if not ok then
		return default
	end
	return lastmod[lastkey] or default
end

cdatabaseable.get = cdatabaseable.query

function cdatabaseable:delete(key)
	local ok,lastkey,lastmod = self:last_key_mod(self.data,key)
	if not ok then
		return nil
	end
	local oldval = lastmod[lastkey]
	lastmod[lastkey] = nil
	self:update("delete",key,oldval,nil)
	return oldval
end

function cdatabaseable:add(key,val)
	local ok,lastkey,lastmod = self:last_key_mod(self.data,key)
	if not ok then
		error(string.format("[cdatabaseable:add] exists same variable, pid=%d key=%s",self.pid,key))
	end
	local oldval = lastmod[lastkey]
	lastmod[lastkey] = (lastmod[lastkey] or 0) + val
	self:update("add",key,oldval,lastmod[lastkey])
	return oldval
end

return cdatabaseable
