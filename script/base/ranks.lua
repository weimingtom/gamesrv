cranks = class("cranks")

-- 关键字和比较字段只支持整数、字符串,1000以内排名效率较好
function cranks:init(name,ids,sortids,param)
	self.name = name
	self.ids = ids
	self.sortids = sortids
	if param then
		self.desc = param.desc and true or false
		self.limit = param.limit or 100
		assert(self.limit > 0)
		self.maxlimit = self.limit * 2
		if param.callback then
			self:register(param.callback)
		end
	end
	self.length = 0
	self.ranks = {}    -- pos:rank
	self.id_rank = {} -- id:rank
end

function cranks:__id(ids)
	return table.concat(ids,"#")
end

function cranks:id(rank)
	local tbl = {}
	for i,key in ipairs(self.ids) do
		local v = assert(self:getattr(rank,key))
		table.insert(tbl,tostring(v))
	end
	return self:__id(tbl)
end

-- 支持带"."的级联字段
function cranks:getattr(rank,attrs)
	local mod = rank
	for attr in string.gmatch(attrs,"([^.]+)%.?") do
		if mod[attr] then
			mod = mod[attr]
		else
			break
		end
	end
	local typ = type(mod)
	assert(typ=="number" or typ=="string")
	return mod
end

-- -<0--rank1需要排在rank2前面，0--rank1和rank2相等,>0--rank1需要排在rank2后面
function cranks:cmp(rank1,rank2)
	local cmpvals1 = {}
	for i,key in ipairs(self.sortids) do
		table.insert(cmpvals1,self:getattr(rank1,key) or false)
	end
	local cmpvals2 = {}
	for i,key in ipairs(self.sortids) do
		table.insert(cmpvals2,self:getattr(rank2,key) or false)
	end
	local length = #cmpvals1
	if self.desc then
		for i = 1,length do
			-- 兼容空字段（排行榜可能会增加比较健）
			if not cmpvals1[i] then
				return 1
			elseif not cmpvals2[i] then
				return -1
			elseif cmpvals1[i] > cmpvals2[i] then
				return -1
			elseif cmpvals1[i] < cmpvals2[i] then
				return 1
			end
		end
	else
		for i = 1,length do
			if not cmpvals1[i] then
				return 1
			elseif not cmpvals2[i] then
				return -1
			elseif cmpvals1[i] < cmpvals2[i] then
				return -1
			elseif cmpvals1[i] > cmpvals2[i] then
				return 1
			end
		end
	end
	return 0
end

--[[
	ranks = cranks.new(...)
	ranks:register({
		onadd = xxx,
		ondel = xxx,
		onupdate = xxx,
	})
]]
function cranks:register(callback)
	self.callback = callback
	-- NOTE: function callback.id(self,rank)
	if callback.id then
		self.id = callback.id
	end
	-- NOTE: function callback.cmp(self,rank1,rank2)
	if callback.cmp then
		self.cmp = callback.cmp
	end
end

function cranks:len()
	return self.length
end

-- 对外简洁接口
function cranks:addorupdate(rank)
	local id = self:id(rank)
	if self:__get(id) then
		return self:update(rank)
	else
		return self:add(rank)
	end
end

-- 根据id获取
-- 格式:1. ranks:get(id1,id2,...) 2. ranks:get({id1,id2,...})
function cranks:get(...)
	local id1 = ...
	local ids = table.pack(...)
	if type(id1) == "table" then
		assert(#ids==1)
		ids=id1
	end
	return self:__get(self:__id(ids))
end

function cranks:getbypos(pos)
	return self.ranks[pos]
end

function cranks:__get(id,ispos)
	return ispos and self.ranks[id] or self.id_rank[id]
end

function cranks:add(rank)
	local id = self:id(rank)
	assert(self.id_rank[id]==nil,"Exists id:" .. tostring(id))
	local length = self:len()
	if length > 0 and self:cmp(self.ranks[length],rank) <= 0 then
		if self.maxlimit and length >= self.maxlimit then
			if self.callback and self.callback.onadd then
				self.callback.onadd(false,rank)
			end
			return false
		end
	else
		if self.maxlimit and length >= self.maxlimit then
			self:del(length,true)
		end
		length = self:len()
	end
	self.id_rank[id] = rank
	self.length = length + 1
	rank.pos = self.length
	self.ranks[rank.pos] = rank
	self:__sort(rank.pos,1)
	if self.callback and self.callback.onadd then
		self.callback.onadd(true,rank)
	end
	return true,rank
end

function cranks:del(id,ispos)
	local rank = ispos and self.ranks[id] or self.id_rank[id]
	if not rank then
		if self.callback and self.callback.ondel then
			self.callback.ondel(false)
		end
		return false
	end
	id = self:id(rank)
	local length = self:len()
	local pos = rank.pos
	self.id_rank[id] = nil
	for i=pos,length-1 do
		self.ranks[i+1].pos = i
		self.ranks[i] = self.ranks[i+1]
	end
	self.ranks[length] = nil
	self.length = length - 1
	if self.callback and self.callback.ondel then
		self.callback.ondel(true,rank)
	end
	return true,rank
end

function cranks:update(newrank)
	local id = self:id(newrank)
	local rank = self.id_rank[id]
	if not rank then
		if self.callback and self.callback.onupdate then
			self.callback.onupdate(false,newrank)
		end
		return false
	end
	local oldpos = rank.pos
	for k,v in pairs(newrank) do
		rank[k] = v
	end
	-- 插入排序
	if self.ranks[oldpos-1] and self:cmp(self.ranks[oldpos-1],rank) > 0 then -- 尝试前移
		self:__sort(oldpos,1)
	elseif self.ranks[oldpos+1] and self:cmp(self.ranks[oldpos+1],rank) < 0 then -- 尝试后移
		self:__sort(oldpos,self:len())
	end
	if self.callback and self.callback.onupdate then
		self.callback.onupdate(true,rank,oldpos)
	end
	return true,rank
end

function cranks:__sort(startpos,endpos)
	--print(startpos,endpos)
	local isgohead = startpos >= endpos
	local rank = self.ranks[startpos]
	assert(rank.pos==startpos)
	local newpos = endpos
	if isgohead then
		for i = startpos-1,endpos,-1 do
			if self:cmp(self.ranks[i],rank) > 0 then
				self.ranks[i].pos = i+1
				self.ranks[i+1] = self.ranks[i]
			else
				newpos = i + 1
				break
			end
		end
	else
		for i = startpos,endpos-1 do
			if self:cmp(self.ranks[i+1],rank) < 0 then
				self.ranks[i+1].pos = i
				self.ranks[i] = self.ranks[i+1]
			else
				newpos = i
				break
			end
		end
	end
	if newpos ~= rank.pos then
		rank.pos = newpos
		self.ranks[rank.pos] = rank
	end
end

function cranks:clear()
	self.length = 0
	self.ranks = {}    -- pos:rank
	self.id_rank = {} -- id:rank
end

-- 存盘相关
function cranks:load(data)
	if not data or not next(data) then
		return
	end
	self.name = data.name
	self.ids = data.ids
	self.sortids = data.sortids
	self.desc = data.desc
	self.ranks = data.ranks
	self.length = #self.ranks
	for i,rank in ipairs(self.ranks) do
		local id = self:id(rank)
		self.id_rank[id] = rank
	end
end

function cranks:save()
	local data = {}
	data.name = self.name
	data.ids = self.ids
	data.sortids = self.sortids
	data.desc = self.desc
	data.ranks = self.ranks
	return data
end

return cranks
