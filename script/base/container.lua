ccontainer = class("ccontainer")

function ccontainer:init(param)
	self.pid = assert(param.pid)
	self.name = assert(param.name)
	self:register(param)
	self.objid = 0
	self.len = 0
	self.objs = {}
end

function ccontainer:clear()
	local objs = self.objs
	self.objs = {}
	self.len = 0
	if self.onclear then
		self:onclear(objs)
	end
end

-- 可重写
function ccontainer:load(data,loadfunc)
	if not data or not next(data) then
		return
	end
	self.objid = data.objid
	local objs = data.objs or {}
	local len = 0
	for id,objdata in pairs(objs) do
		id = tonumber(id)
		local obj = loadfunc and loadfunc(objdata) or objdata
		self.objs[id] = obj
		len = len + 1
	end
	self.len = len
end

-- 可重写
function ccontainer:save(savefunc)
	local data = {}
	data.objid = self.objid
	local objs = {}
	for id,obj in pairs(self.objs) do
		id = tostring(id)
		objs[id] = savefunc and savefunc(obj) or obj
	end
	data.objs = objs
	return data
end

function ccontainer:register(callback)
	if callback then
		if callback.onclear then
			self.onclear = callback.onclear
		elseif callback.onadd then
			self.onadd = callback.onadd
		elseif callback.ondel then
			self.ondel = callback.ondel
		elseif callback.onupdate then
			self.onupdate = callback.onupdate
		end
	end
end

function ccontainer:genid()
	if self.objid >= MAX_NUMBER then
		self.objid = 0
	end
	self.objid = self.objid + 1
	return self.objid
end

function ccontainer:add(obj,id)
	id = id or self:genid()
	assert(self.objs[id]==nil,"Exist Object:" .. tostring(id))
	obj.id = id
	self.objs[id] = obj
	self.len = self.len + 1
	if self.onadd then
		self:onadd(obj)
	end
end

function ccontainer:del(id)
	local obj = self:get(id)
	if obj then
		assert(obj.id==id)
		self.objs[id] = nil
		self.len = self.len - 1
		if self.ondel then
			self:ondel(obj)
		end
	end
end

function ccontainer:update(id,attrs)
	local obj = self:get(id)
	if obj then
		for k,v in pairs(attrs) do
			obj[k] = v
		end
		if self.onupdate then
			self:onupdate(id,attrs)
		end
	end
end

function ccontainer:get(id)
	return self.objs[id]
end

return ccontainer
