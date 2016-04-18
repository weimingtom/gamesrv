citemdb = class("citemdb",ccontainer)

function citemdb:init(pid)
	ccontainer.init(self,{
		pid = pid,
		name = "citemdb",
	})
	self.pid = pid
	self.space = ITEMBAG_SPACE
	self.expandspace = 0
	self.pos_id = {}
	self.type_ids = {}
	self.loadstate = "unload"
end

function citemdb:load(data)
	if not data or not next(data) then
		return
	end
	ccontainer.load(self,data,function (itemdata)
		local item = citem.new()
		item:load(itemdata)
		return item
	end)
	self.expandspace = data.expandspace
end

function citemdb:save()
	local data = {}
	ccontainer.save(self,function (item)
		return item:save()
	end)
	data.expandspace = self.expandspace
	return data
end

function citemdb:clear()
	ccontainer.clear(self)
	self.expandspace = 0
	self.pos_id = {}
	self.type_ids = {}
end

function citemdb:oncreate(player)
end

function citemdb:onlogin(player)
end

function citemdb:onlogoff(player)
end

function citemdb:genid()
	return ccontainer.genid(self)
end

function citemdb:newitem(itemdata)
	require "script.item.init"
	return citem.new(itemdata)
end

function citemdb:additem(item,reason)
	local itemid = item.id
	local itemtype = item.type
	local pos = self:getfreepos()
	if not pos then
		mailmgr.sendmail(self.pid,{
			srcid = 0,
			author = "系统",
			title = "背包空间不足",
			content = "背包空间不足",
			attach = {
				item,
			},
		})
	end
	local itemid = self:genid()
	logger.log("info","item",string.format("[additem] pid=%s itemid=%s itemtype=%s num=%s pos=%s reason=%s",self.pid,itemid,itemtype,item.num,pos,reason))
	item.pos = pos
	self:add(obj,itemid)
	self.pos_id[pos] = itemid
	if not self.type_ids[itemtype] then
		self.type_ids[itemtype] = {}
	end
	table.insert(self.type_ids[itemtype],itemid)
end

function citemdb:delitem(itemid,reason)
	local item = self:getitem(itemid)
	if item then
		local pos = assert(item.pos,"No pos item:" .. tostring(itemid))
		local itemtype = item.type
		logger.log("info","item",string.format("[delitem] pid=%s itemid=%s itemtype=%s num=%s pos=%s reason=%s",self.pid,itemid,itemtype,item.num,pos,reason))
		self:del(itemid)
		self.pos_id[pos] = nil
		if self.type_ids[itemtype] then
			for pos,id in ipairs(self.type_ids[itemtype]) do
				if id == itemid then
					table.remove(self.type_ids[itemtype],pos)
					break
				end
			end
		end
		return item
	end
end

function citemdb:getitem(itemid)
	return self:get(itemid)
end

function citemdb:getitemsbytype(itemtype)
	local ids = self.type_ids[itemtype]
	if ids then
		local items = {}
		for i,itemid in ipairs(ids) do
			table.insert(items,self:getitem(itemid))
		end
		return items
	end
end

function citemdb:getnumbytype(itemtype)
	local num = 0
	local items = self:getitembytype(itemtype)
	for i,item in ipairs(items) do
		num = num + item.num
	end
	return num
end

function citemdb:costitembytype(itemtype,num,reason)
	local hasnum = self:getnumbytype(itemtype)
	if hasnum < num then
		return 0
	end
	local items = self:getitemsbytype(itemtype)
	if items then
		logger.log("info","item",string.format("[costitembytype] pid=%s itemtype=%s num=%s reason=%s",self.pid,itemtype,num,reason))
		local costnum = num
		items = table.sort(items,citemdb.order_costitem)
		for i,item in ipairs(items) do
			if costnum >= item.num then
				costnum = costnum - item.num
				self:delitem(item.id)
			else
				item.num = item.num - costnum
				break
			end
		end
	end
	return num
end

function citemdb:additembytype(itemtype,num,bind,reason)
	local itemdata = assert(getitemdata(itemtype),"Invalid itemtype:" .. tostring(itemtype))
	logger.log("info","item",string.format("[additembytype] pid=%s itemtype=%s num=%s bind=%s reason=%s",self.pid,itemtype,num,bind,reason))
	local items = self:getitemsbytype(itemtype)
	if not items then
		self:__additembytype(itemtype,num,bind,reason)
	end
	for i,item in ipairs(items) do
		if num > 0 then
			if item.num < itemdata.maxnum and item.bind == bind then
				local addnum = itemdata.maxnum - item.num
				item.num = item.num + addnum
				num = num - addnum
			end
		end
	end
	self:__additembytype(itemtype,num,bind,reason)
end

function citemdb:__additembytype(itemtype,num,bind,reason)
	local itemdata = assert(getitemdata(itemtype),"Invalid itemtype:" .. tostring(itemtype))
	if num > 0 then
		local needpos = math.ceil(num/itemdata.maxnum)
		local freepos = self:getfreepos()
		local usepos = math.min(needpos,freepos)
		for i=1,usepos do
			local itemnum = math.min(itemdata.maxnum,num)
			num = num - itemnum
			local item = self:newitem({
				type=itemtype,
				num = itemnum,
				bind = bind,
			})
			self:additem(item,reason)
		end
		while num > 0 do
			mailmgr.sendmail(self.pid,{
				srcid = 0,
				author = "系统",
				title = "背包空间不足",
				content = "背包空间不足",
				attach = {
					{itemtype=itemtype,num=num,bind=bind},
				},
			})
		end
	end
end

function citemdb:getusespace()
	return self.len
end

function citemdb:getfreespace()
	return self:getspace() - self:getusespace()
end

function citemdb:getspace()
	return self.expandspace + self.space
end

function citemdb:getfreepos()
	local space = self:getspace()
	for pos=1,space do
		if not self.pos_id[pos] then
			return pos
		end
	end
end

function citemdb:expandspace(addspace)
	logger.log("info","item",string.format("[expandspace] pid=%s addspace=%s",self.pid,addspace))
	self.expandspace = addspace
end

function citemdb.order_costitem(item1,item2)
	if item1.bind then
		return true
	end
	if item2.bind then
		return false
	end
	return true
end

return citemdb
