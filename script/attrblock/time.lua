

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
	if conf.callback then
		self:register(conf.callback)
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

function ctoday:register(callback)
	if callback.onclear then
		self.onclear = callback.onclear()
	end
end

function ctoday:clear()
	if self.onclear then
		self:onclear()
	end
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

function ctoday:query(key,default,nocheck)
	if not nocheck then
		self:checkvalid()
	end
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
	-- 每日5点看成凌晨0点
	--local hour = getdayhour()
	--if self.dayno + 1 == nowday then
	--	if hour < 5 then
	--		return
	--	end
	--end
	--self:clear()
	--self.dayno = hour < 5 and nowday-1 or nowday
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
	---- 下周一5点时才重置
	--local weekday = getweekday()
	--local hour = getdayhour()
	--if self.dayno + 1 == nowweek then
	--	if weekday == 1 and hour < 5 then
	--		return
	--	end
	--end
	--self:clear()
	--self.dayno = (weekday == 1 and hour < 5) and nowweek - 1 or nowweek
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
	---- 下周天5点时才重置
	--local weekday = getweekday()
	--local hour = getdayhour()
	--if self.dayno + 1 == nowweek2 then
	--	if weekday == 0 and hour < 5 then
	--		return
	--	end
	--end
	--self:clear()
	--self.dayno = (weekday == 0 and hour < 5) and nowweek2 - 1 or nowweek2
end

-- cthistemp(带生命周期时间对象)
cthistemp = class("cthistemp",cdatabaseable)
function cthistemp:init(conf)
	cdatabaseable.init(self,conf)
	self.data = {}
	self.time = {}

	self.timer = {}
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
	for flag,timerid in pairs(self.timer) do
		local callback = timer.untimeout(flag,timerid)
		if callback then
			callback()
		end
	end
end

function cthistemp:checkvalid(key)
	local ok,lastkey,lastmod = cdatabaseable.last_key_mod(self,self.time,key)
	if ok then
		local exceedtime = lastmod[lastkey] or 0
		local now = os.time()
		if exceedtime <= now then
			lastmod[lastkey] = nil
			cdatabaseable.delete(self,key)
		end
	end
	return ok,lastkey,lastmod
end


--未指定secs,对象生命期不变
function cthistemp:set(key,val,secs,callback)
	local ok,lastkey,lastmod = self:checkvalid(key)
	if not ok then
		error(string.format("[cthistemp:set] key branch conflict, pid=%d key=%s lastkey=%s lastmod=%s",self.pid,key,lastkey,lastmod))
	end
	local oldval = cdatabaseable.set(self,key,val)
	local old_exceedtime = lastmod[lastkey]
	if secs then
		lastmod[lastkey] = os.time() + secs
		self:deltimer(key)
		if callback then
			self:addtimer(key,secs,callback)
		end
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
	local ok,lastkey,lastmod = self:checkvalid(key)
	if not ok then
		return default,nil
	end
	return cdatabaseable.query(self,key,default),lastmod[lastkey]
end

cthistemp.get = cthistemp.query

function cthistemp:delete(key)
	local ok,lastkey,lastmod = cdatabaseable.last_key_mod(self,self.time,key)
	if not ok then
		return nil,nil
	end
	return self:__delete(key,lastkey,lastmod)
end

function cthistemp:__delete(key,lastkey,lastmod)
	local old_exceedtime = lastmod[lastkey]
	lastmod[lastkey] = nil
	local timerid = self:gettimer(key)
	if timerid then
		self:deltimer(key)
	end
	return cdatabaseable.delete(self,key),old_exceedtime
end

function cthistemp:getexceedtime(key)
	local ok,lastkey,lastmod = self:checkvalid(key)
	if not ok then
		return nil
	end
	return lastmod[lastkey]
end

-- 延长生命周期(对已失效的key值无效)
function cthistemp:delay(key,secs)
	local ok,lastkey,lastmod = self:checkvalid(key)
	if not ok then
		error(string.format("[cthistemp:delay] key branch conflict, pid=%d key=%s lastkey=%s lastmod=%s",self.pid,key,lastkey,lastmod))
	end
	if lastmod[lastkey] then
		lastmod[lastkey] = lastmod[lastkey] + secs
		local callback = self:deltimer(key)
		if callback then
			local cd = lastmod[lastkey] - os.time()
			self:addtimer(key,cd,callback)
		end
	end
end

-- private method
function cthistemp:gettimer(key)
	local flag = string.format("timer.%s.%s.%s",self.__flag,self.pid,key)
	return self.timer[flag]
end

function cthistemp:addtimer(key,cd,callback)
	local flag = string.format("timer.%s.%s.%s",self.__flag,self.pid,key)
	local timerid = timer.timeout(flag,cd,callback)
	self.timer[flag] = timerid
end

function cthistemp:deltimer(key)
	local timerid = self:gettimer(key)
	if timerid then
		--return timer.deltimerbyid(timerid)
		local flag = string.format("timer.%s.%s.%s",self.__flag,self.pid,key)
		return timer.untimeout(flag,timerid)
	end
end
