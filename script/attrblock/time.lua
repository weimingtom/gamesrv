

-- ctoday
ctoday = class("ctoday",cdatabaseable)

function ctoday:init(conf)
	cdatabaseable.init(self,conf)
	self.data = {}
	self.dayno = getdayno()
	self.objs = {}
	if conf.objs then
		for k,v in pairs(conf.objs) do
			self:setobject(k,v)
		end
	end
end


function ctoday:save()
	local data = {}
	data["dayno"] = self.dayno
	data["data"] = self.data
	local objdata = {}
	for k,obj in pairs(self.objs) do
		objdata[k] = obj:save()
	end
	data["objs"] = objdata
	return data
end

function ctoday:load(data)
	if not data or not next(data) then
		return
	end
	self.dayno = data["dayno"]
	self.data = data["data"]
	local objdata = data["objs"] or {}
	for k,v in pairs(objdata) do
		self.objs[k]:load(v)
	end
end

function ctoday:clear()
	self.data = {}
	--对象的清空操作放到getobject中执行，否则对象会被连续清空两次，无意义
--	for key,obj in pairs(self.objs) do
--		obj:clear()
--		self:setobject(key,obj)
--	end
end

function ctoday:set(key,val)
	self:checkvalid()
	return cdatabaseable.set(self,key,val)
end

function ctoday:query(key,default)
	self:checkvalid()
	return cdatabaseable.query(self,key,default)
end

function ctoday:add(key,val)
	self:checkvalid()
	return cdatabaseable.add(self,key,val)
end

function ctoday:checkvalid()
	local nowday = getdayno()
	if self.dayno == nowday then
		return
	end
	self:clear()
	self.dayno = nowday
end

function ctoday:setobject(key,obj)
	self:set(key,true)
	self.objs[key] = obj
end

function ctoday:getobject(key)
	local flag = self:query(key,false)
	local obj = self.objs[key]
	assert(obj,"invalid object key:" .. tostring(key))
	if not flag then
		obj:clear()
		self:setobject(key,obj)
	end
	return obj
end


-- cthisweek(以星期一为一周开始)
cthisweek = class("cthisweek",ctoday)
function cthisweek:init(conf)
	ctoday.init(self,conf)
	self.dayno = getweekno()
end

function cthisweek:checkvalid() 
	local nowweek = getweekno()
	if self.dayno == nowweek then
		return
	end
	self:clear()
	self.dayno = nowweek
end

-- cthisweek2(以星期天为一周开始)
cthisweek2 = class("cthisweek2",ctoday)
function cthisweek2:init(conf)
	ctoday.init(self,conf)
	self.dayno = getweekno(2)
end

function cthisweek2:checkvalid()
	local nowweek2 = getweekno(2)
	if self.dayno == nowweek2 then
		return
	end
	self.data = {}
	self.dayno = nowweek2
end

-- cthistemp(带生命周期时间对象)
cthistemp = class("cthistemp",cdatabaseable)
function cthistemp:init(conf)
	cdatabaseable.init(self,conf)
	self.data = {}
	self.time = {}
end

function cthistemp:save()
	local data = {}
	data["data"] = self.data
	data["time"] = self.time
	return data
end

function cthistemp:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data["data"]
	self.time = data["time"]
end

function cthistemp:clear()
	self.data = {}
	self.time = {}
end

function cthistemp:checkvalid(key,lastkey,lastmod)
	local exceedtime = lastmod[lastkey] or 0
	if exceedtime > getsecond() then
		return
	end
	lastmod[lastkey] = nil
	cdatabaseable.delete(self,key)
end

--未指定secs,对象生命期不变
function cthistemp:set(key,val,secs)
	local ok,lastkey,lastmod = cdatabaseable.last_key_mod(self,self.time,key)
	if not ok then
		error(string.format("[cthistemp:set] key branch conflict, pid=%d key=%s lastkey=%s lastmod=%s",self.pid,key,lastkey,lastmod))
	end
	self:checkvalid(key,lastkey,lastmod)
	local oldval = cdatabaseable.set(self,key,val)
	local old_exceedtime = lastmod[lastkey]
	if secs then
		lastmod[lastkey] = getsecond() + secs
	end
	return oldval,old_exceedtime
end

--[[ 调用前需要保证该key仍然有效
-- 如:  local exceedtime = thistemp:getexceedtime(key)
--		if exceedtime then
--			thistemp:add(key,addval)
--		else
--			local new_val = xxx
--			local new_exceedtime = xxx
--			thistemp:set(key,new_val,new_exceedtime)
--		end
]]
function cthistemp:add(key,val)
	return cdatabaseable.add(self,key,val)
end

function cthistemp:query(key,default)
	local ok,lastkey,lastmod = cdatabaseable.last_key_mod(self,self.time,key)
	if not ok then
		return default,nil
	end
	self:checkvalid(key,lastkey,lastmod)
	return cdatabaseable.query(self,key,default),lastmod[lastkey]
end

cthistemp.get = cthistemp.query

function cthistemp:delete(key)
	local ok,lastkey,lastmod = cdatabaseable.last_key_mod(self,self.time,key)
	if not ok then
		return nil,nil
	end
	local old_exceedtime = lastmod[lastkey]
	lastmod[lastkey] = nil
	return cdatabaseable.delete(self,key),old_exceedtime
end

function cthistemp:getexceedtime(key)
	local ok,lastkey,lastmod = cdatabaseable.last_key_mod(self,self.time,key)
	if not ok then
		return nil
	end
	self:checkvalid(key,lastkey,lastmod)
	return lastmod[lastkey]
end

-- 延长生命周期(对已失效的key值无效)
function cthistemp:delay(key,secs)
	local ok,lastkey,lastmod = cdatabaseable.last_key_mod(self,self.time,key)
	if not ok then
		error(string.format("[cthistemp:delay] key branch conflict, pid=%d key=%s lastkey=%s lastmod=%s",self.pid,key,lastkey,lastmod))
	end
	self:checkvalid(key,lastkey,lastmod)
	if lastmod[lastkey] then
		lastmod[lastkey] = lastmod[lastkey] + secs
	end
end

