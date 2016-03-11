ccardtablelib = class("ccardtablelib")

function ccardtablelib:init(pid)
	self.pid = pid
	self.cardtableid = 0
	-- 所有卡表库中的卡表共享卡表ID
	self.name_cardtabledb = {}
	-- 普通对战卡表库
	self:addcardtabledb(ccardtabledb.new{pid=self.pid,name="fight"})
	-- 娱乐对战卡表库
	self:addcardtabledb(ccardtabledb.new{pid=self.pid,name="yule"})
	-- 竞技场对战卡表库
	self:addcardtabledb(ccardtabledb.new{pid=self.pid,name="arena"})
	
end

function ccardtablelib:load(data)
	if not data or not next(data) then
		return
	end
	self.cardtableid = data.cardtableid
	for name,_ in pairs(self.name_cardtabledb) do
		local cardtabledb = self:getcardtabledb(name)
		cardtabledb:load(data[name])
	end
end

function ccardtablelib:save()
	local data = {}
	data.cardtableid = self.cardtableid
	for name,_ in pairs(self.name_cardtabledb) do
		local cardtabledb = self:getcardtabledb(name)
		data[name] = cardtabledb:save()
	end
	return data
end

function ccardtablelib:clear()
	for name,_ in pairs(self.name_cardtabledb) do
		local cartabledb = self:getcardtabledb(name)
		cardtabledb:clear()
	end
end

function ccardtablelib:getcardtabledb(name)
	assert(self.name_cardtabledb[name]~=nil)
	return self[name]
end

--/*
--增加/注册一个卡表库
--*/
function ccardtablelib:addcardtabledb(cardtabledb)
	local name = assert(cardtabledb.name)
	assert(self.name_cardtabledb[name]==nil)
	self[name] = cardtabledb
	self.name_carddb[name] = true
	return cardtabledb
end


function ccardtablelib:gencardtableid()
	self.cardtableid = self.cardtableid + 1
	return self.cardtableid
end


function ccardtable:getcardtable(id)
	for name,_ in pairs(self.name_cardtabledb) do
		local cardtabledb = self:getcardtabledb(name)
		local cardtable = cardtabledb:getcardtable(name)
		if cardtable then
			return cardtable
		end
	end
end


--/*
--增加卡表
--@param table cardtable
--@example:
--xxx:addcardtable("arean",{
--	name = "测试卡表",
--  cards = {141001,...} -- 30个卡牌
--},"test")
--*/
function ccardtablelib:addcardtable(mode,cardtable,reason)
	local cardtabledb = assert(self:getcardtabledb(mode))
	local pos = cardtabledb:getfreepos()
	if not pos then
		return
	end
	local id = self:gencardtableid()
	cardtable.id = id
	return cardtabledb:addcardtable(cardtable,reason)
end


function ccardtable:delcardtable(id,reason)
	for name,_ in pairs(self.name_cardtabledb) do
		local cardtabledb = self:getcardtabledb(name)
		local cardtable = cardtabledb:delcardtable(id,reason)
		if cardtable then
			return cardtable
		end
	end
end

return ccardtablelib
