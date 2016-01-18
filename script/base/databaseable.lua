require "script.base.class"
require "script.base.netcache"

cdatabaseable = class("cdatabaseable")

cdatabaseable.new = nil

function cdatabaseable:init(param)
	self.pid = assert(param.pid,"no pid")
	self.__flag = assert(param.flag,"no flag")
	self.dirty = true
	self.loadstate = "unload"
end

function cdatabaseable:clear()
	self.dirty = false
	self.data = {}
end

function cdatabaseable:isdirty()
	return self.dirty
end

function cdatabaseable:updated()
	return self:isdirty()
end

function cdatabaseable:__getattr(attrs,data)
	local mod = data or self.data
	for i,attr in ipairs(attrs) do
		if not mod[attr] then
			mod[attr] = {}
		end
		mod = mod[attr]
	end
	return mod
end

function cdatabaseable:__split(key)
	local tbl = {}
	for attr in string.gmatch(key,"([^.]+)%.?") do
		assert(string.match(attr,"^[%w_]+$"),string.format("Invalid Attr:'%s'",key))
		table.insert(tbl,attr)
	end
	return tbl
end

-- 兼容旧格式
function cdatabaseable:last_key_mod(data,key)
	local attrs = self:__split(key)
	local lastkey = table.remove(attrs)
	local lastmod = self:__getattr(attrs,data)
	if type(lastmod) ~= "table" then
		return false
	end
	return true,lastkey,lastmod
end

function cdatabaseable:get(key,default)
	local attrs = self:__split(key)
	local lastkey = table.remove(attrs)
	local mod = self:__getattr(attrs)
	return mod[lastkey] or default
end

cdatabaseable.query = cdatabaseable.get

function cdatabaseable:__set(key,val)
	local attrs = self:__split(key)
	local lastkey = table.remove(attrs)
	local mod = self:__getattr(attrs)
	local oldval = mod[lastkey]
	mod[lastkey] = val
	return oldval
end

function cdatabaseable:set(key,val)
	local oldval = self:__set(key,val)
	self:update("set",key,oldval,val)
	return oldval
end

function cdatabaseable:add(key,val)
	local oldval = self:get(key)
	local newval = (oldval or 0) + val
	self:update("add",key,oldval,newval)
	return self:__set(key,newval)
end

function cdatabaseable:delete(key)
	local attrs = self:__split(key)
	local lastkey = table.remove(attrs)
	local mod = self:__getattr(attrs)
	local oldval = mod[lastkey]
	mod[lastkey] = nil
	self:update("delete",key,oldval,nil)
	return oldval
end

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

function cdatabaseable:basic_get(key,default)
	return self.data[key] or default
end

cdatabaseable.basic_query = cdatabaseable.basic_get

function cdatabaseable:basic_set(key,val)
	local oldval = self.data[key]
	self.data[key] = val
	self:update("set",key,oldval,val)
	return oldval
end

function cdatabaseable:basic_add(key,val)
	local oldval = self.data[key]
	local newval = (oldval or 0) + val
	self.data[key] = newval
	self:update("add",key,oldval,newval)
	return oldval
end

function cdatabaseable:basic_delete(key)
	local oldval = self.data[key]
	self.data[key] = nil
	self:update("delete",key,oldval,nil)
	return oldval
end

return cdatabaseable
