ccardtabledb = class("ccardtabledb",ccontainer)

function ccardtabledb:init(conf)
	self.name = assert(conf.name)
	ccontainer.init(self,conf)
	self.pos_id = {} -- 卡表位置：卡表ID
	self.maxlen = 8  -- 最大卡表数
end

function ccardtabledb:load(data)
	if not data or not next(data) then
		return
	end
	ccontainer.load(self,data)
	for id,cardtable in pairs(self.objs) do
		local pos = assert(cardtable.pos)
		self.pos_id[pos] = id
	end
end

function ccardtabledb:save()
	return ccontainer.save(self)
end

function ccardtabledb:clear()
	ccontainer.clear(self)
	self.pos_id = {}
end

function ccardtabledb:getcardtable(id)
	return self:get(id)
end

function ccardtabledb:getcardtablebypos(pos)
	local id = self.pos_id[pos]
	if id then
		return self:getcardtable(id)
	end
end

function ccardtabledb:getfreepos()
	for pos=1,self.maxlen do
		if not self.pos_id[pos] then
			return pos
		end
	end
end

--/*
--增加卡表
--@param table cardtable
--@example:
--xxx:addcardtable({
--	id = 1,
--	name = "测试卡表",
--	race = 1,
--  cards = {141001,...} -- 30个卡牌
--},"test")
--*/
function ccardtabledb:addcardtable(cardtable,reason)
	local id = assert(cardtable.id)
	local pos = self:getfreepos()
	if not pos then
		return
	end
	logger.log("info","cardtable",format("[addcardtable] name=%s pid=%s id=%s pos=%s cardtable=%s reason=%s",self.name,self.pid,id,pos,cardtable,reason))
	cardtable.pos = pos
	self.pos_id[pos] = id
	self:add(cardtable,id)
	return pos
end

function ccardtabledb:delcardtable(id,reason)
	local cardtable = self:getcardtable(id)
	if not cardtable then
		return
	end
	local pos = assert(cardtable.pos)
	logger.log("info","cardtable",string.format("[delcardtable] name=%s pid=%s id=%s pos=%s reason=%s",self.name,self.pid,id,pos,reason))
	self.pos_id[pos] = nil
	self:del(id)
	return cardtable
end

function ccardtabledb:delcardtablebypos(pos,reason)
	local id = self.pos_id[pos]
	if id then
		return self:delcardtable(id,reason)
	end
end

return ccardtabledb
