
require "script.war.aux"

ccardtablelib = class("ccardtablelib",cdatabaseable)

function ccardtablelib:init(pid)
	self.flag = "ccardtablelib"	
	cdatabaseable.init(self,{
		pid = pid,
		flag = self.flag,
	})
	self.data = {}
	self.normal_cardtablelib = {}
	self.nolimit_cardtablelib = {}
end

function ccardtablelib:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data.data
	for k,v in pairs(data.normal_cardtablelib) do
		local cards = v.cards
		v.cards = nil
		local d = {}
		for k1,v1 in pairs(cards) do
			d[tonumber(k1)] = v1
		end
		v.cards = d
		self.normal_cardtablelib[tonumber(k)] = v
	end
	for k,v in pairs(data.nolimit_cardtablelib) do
		local cards = v.cards
		v.cards = nil
		local d = {}
		for k1,v1 in pairs(cards) do
			d[tonumber(k1)] = v1
		end
		v.cards = d
		self.nolimit_cardtablelib[tonumber(k)] = v
	end
end

function ccardtablelib:save()
	local data = {}
	data.data = self.data
	data.normal_cardtablelib = self.normal_cardtablelib
	data.nolimit_cardtablelib = self.nolimit_cardtablelib
	return data
end

function ccardtablelib:clear()
	self.data = {}
	self.normal_cardtablelib = {}
	self.nolimit_cardtablelib = {}
end

function ccardtablelib:checkcardtable(cardtable)
	local player = playermgr.getplayer(self.pid)
	local sid_num = {}
	cardtable = copy(cardtable)
	for i,sid in ipairs(cardtable.cards) do
		if not sid_num[sid] then
			sid_num[sid] = 0
		end
		sid_num[sid] = sid_num[sid] + 1
	end
	if cardtable.mode == CARDTABLE_MODE_NORMAL then
		for sid,num in pairs(sid_num) do
			local carddb = player:getcarddbbysid(sid)
			if carddb:getamountbysid(sid) < num then
				return false,sid
			end
		end
	end
	cardtable.cards = sid_num
	return true,cardtable
end

function ccardtablelib:updatecardtable(cardtable)
	local id = cardtable.id
	assert(1 <= id and id <= 8,"Invalid cardtable id:" .. tostring(id))
	local ok,result = self:checkcardtable(cardtable)
	if not ok then
		return {result = result,}
	end
	cardtable = result
	logger.log("info","cardtable",format("#%d updatecardtable,cardtable=%s",self.pid,cardtable))
	local mode = cardtable.mode
	if mode == CARDTABLE_MODE_NORMAL then
		self.normal_cardtablelib[id] = cardtable
	else
		self.nolimit_cardtablelib[id] = cardtable
	end
	return {result = 0,}
end

function ccardtablelib:delcardtable(id,mode)
	assert(1 <= id and id <= 8,"Invalid cardtable id:" .. tostring(id))
	logger.log("info","cardtable",string.format("#%d delcardtable,id=%d mode=%d",self.pid,id,mode))
	if mode == CARDTABLE_MODE_NORMAL then
		self.normal_cardtablelib[id] = nil
	else
		self.nolimit_cardtablelib[id] = cardtable
	end
end

function ccardtablelib:getcardtable(id,mode)
	assert(1 <= id and id <= 8,"Invalid cardtable id:" .. tostring(id))
	if mode == CARDTABLE_MODE_NORMAL then
		return self.normal_cardtablelib[id]
	else
		return self.nolimit_cardtablelib[id]
	end
end

return ccardtablelib
