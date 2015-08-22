
require "script.war.aux"

ccategorytarget = class("ccategorytarget")

function ccategorytarget:init(conf)
	self.pid = conf.pid
	self.warid = conf.warid
	self.flag = conf.flag
	self.num = 0
	self.id_obj = {}
	self.halos = {}
	self.onaddhp = {}
	self.onhurt = {}
	self.ondie = {}
	self.oncheckdie = {}
	self.ondefense = {}
	self.onattack = {}
	self.onadd = {}
	self.ondel = {}
end

function ccategorytarget:addobj(obj)
	local id = obj.id
	assert(self.id_obj[id] == nil,"Repeat warcardid:" .. tostring(id))
	logger.log("debug","war",string.format("[warid=%d] #%d %s.addobj,cardid=%d cardsid=%d",self.warid,self.pid,self.flag,obj.id,obj.sid))
	self.num = self.num + 1
	self.id_obj[id] = obj
	self:__onadd(obj)
end

function ccategorytarget:delobj(id)
	local obj = self.id_obj[id]
	if obj then
		logger.log("debug","war",string.format("[warid=%d] #%d %s.delobj,cardid=%d",self.warid,self.pid,self.flag,obj.id))
		self:__ondel(obj)
		self.id_obj[id] = nil
		self.num = self.num - 1
	end
end

function ccategorytarget:addbuff(value,srcid,srcsid)
	for warcardid,warcard in pairs(self.id_obj) do
		if warcardid ~= srcid then
			warcard:addbuff(value,srcid,srcsid)
		end
	end
end

function ccategorytarget:delbuff(srcid)
	for warcardid,warcard in pairs(self.id_obj) do
		if warcardid ~= srcid then
			warcard:delbuff(srcid)
		end
	end
end

function ccategorytarget:addhalo(value,srcid,srcsid)
	table.insert(self.halos,{srcid=srcid,srcsid=srcsid,value=value})
	for warcardid,warcard in pairs(self.id_obj) do
		if warcardid ~= srcid then
			warcard:addhalo(value,srcid,srcsid)
		end
	end
end

function ccategorytarget:delhalo(srcid,start)
	start = start or 1
	local pos
	for i = start,#self.halos do
		local halo = self.halos[i]
		if halo.srcid == srcid then
			pos = i
			break
		end
	end
	if pos then
		table.remove(self.halos,pos)
		for warcardid,warcard in pairs(self.id_obj) do
			if warcardid ~= srcid then
				warcard:delhalo(srcid)
			end
		end
	end
end

function ccategorytarget:checklifecircle()
	for i = #self.halos,1,-1 do
		local halo = self.halos[i]
		if halo.value.lifecircle then
			halo.value.lifecircle = halo.value.lifecircle - 1
			if halo.value.lifecircle <= 0 then
				self:delhalo(halo.srcid,i)
			end
		end
	end
end

function ccategorytarget:gethurtorder()
	-- need modify
	return values(self.id_obj)
end

function ccategorytarget:allid()
	return keys(self.id_obj)
end

function ccategorytarget:addhp(value,srcid)
	local objs = self:gethurtorder()
	for i,obj in ipairs(objs) do
		obj:addhp(value,srcid)
	end
end

function ccategorytarget:setstate(type,value)
	for id,warcard in pairs(self.id_obj) do
		warcard:setstate(type,value)
	end
end

function ccategorytarget:delstate(type)
	for id,warcard in pairs(self.id_obj) do
		warcard:delstate(type)
	end
end


function ccategorytarget:__onadd(warcard)
	for i,v in ipairs(self.halos) do
		warcard:addhalo(v.value,v.srcid,v.srcsid)
	end
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.onadd) do
		owner = war:getowner(id)
		card = owner.id_card[id]
		cardcls = getclassbycardsid(card.sid)
		eventresult = cardcls.__onadd(card,warcard)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function ccategorytarget:__ondel(warcard)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,card,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.ondel) do
		owner = war:getowner(id)
		card = owner.id_card[id]
		cardcls = getclassbycardsid(card.sid)
		eventresult = cardcls.__ondel(card,warcard)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function ccategorytarget:dump()
	local data = {}
	data.pid = self.pid
	data.warid = self.warid
	data.allid = self:allid()
	data.halos = self.halos
	data.onhurt = self.onhurt
	data.ondefense = self.ondefense
	data.onattack = self.onattack
	data.onadd = self.onadd
	data.ondel = self.ondel
	return data
end

return ccategorytarget
