
require "script.playermgr"
require "script.war.aux"

local function test(pid)
	pid = assert(tonumber(pid),"Invalid pid:" .. tostring(pid))
	local player = playermgr.getplayer(pid)	
	if not player then
		return	
	end
	player.carddb:clear()
	player.cardtablelib:clear()

	local carddb = player:getcarddbbysid(11201)
	carddb:addcardbysid(11201,3)
	assert(carddb:getamountbysid(11201) == 3)
	carddb:delcardbysid(11201,1)
	assert(carddb:getamountbysid(11201) == 2)
	local ok,result = pcall(carddb.delcardbysid,carddb,11201,4) -- not enough
	assert(ok == false)
	assert(carddb:getamountbysid(11201) == 2)
	carddb:delcardbysid(11201,2)
	assert(carddb:getamountbysid(11201)==0)
	carddb:addcardbysid(11201,4)
	assert(carddb:getamountbysid(11201) == 4)
	local carddb2 = player:getcarddbbysid(21101)
	carddb2:addcardbysid(21101,3)
	assert(carddb2:getamountbysid(21101) == 3)
	local ok,result = pcall(carddb.addcardbysid,carddb,1111111,10,"test") --error,card sid non exists
	assert(ok == false)

	-- compose/decompose
	player:set("chip",0)
	local cards = carddb.sid_cards[11201]
	local card = cards[1]
	local sid = card.sid
	local decomposechip = card.decomposechip
	local composechip = card.composechip
	local num1 = carddb:getamountbysid(sid)
	carddb:decompose(card,1)
	print(num1,carddb:getamountbysid(sid))
	assert(num1 - 1 == carddb:getamountbysid(sid))
	print(player:getchip(),decomposechip)	
	assert(player:getchip() == decomposechip)
	local num1 = carddb:getamountbysid(sid)
	carddb:compose(sid)  -- chip not enough
	assert(num1 == carddb:getamountbysid(sid))
	player:addchip(composechip-decomposechip,"test")
	carddb:compose(sid)
	assert(num1 + 1 == carddb:getamountbysid(sid))
	assert(player:getchip() == 0)
	local cardcls = getclassbycardsid(sid)
	local addchip = math.max(0,carddb:getamountbysid(11201) - cardcls.max_amount) * cardcls.decomposechip
	cardcls2 = getclassbycardsid(21101)
	addchip = addchip + math.max(0,carddb2:getamountbysid(21101) - cardcls2.max_amount) * cardcls2.decomposechip
	print(carddb.__flag)
	for _,sid in ipairs({11201,21101,}) do
		local tmpdb = player:getcarddbbysid(sid)
		tmpdb:decomposeleft()
	end
	assert(player:getchip() == addchip)
	assert(carddb:getamountbysid(11201) == cardcls.max_amount)
	assert(carddb:getamountbysid(21101) == cardcls2.max_amount)
	pprintf("card:%s",player.carddb:save())

	-- cardtable
	local cards = randomcard(30,2)
	local cardtable = {
		id = 9,
		race = 1,
		cards = cards,
		mode = 0,
	}
	local ok,result = pcall(player.cardtablelib.updatecardtable,player.cardtablelib,cardtable)
	assert(ok == false)
	cardtable.id = 1
	assert(player.cardtablelib.normal_cardtablelib[1] == nil)
	local result = player.cardtablelib:updatecardtable(cardtable)
	assert(result.result ~= 0) -- card not enough
	for _,sid in ipairs(cardtable.cards) do
		local carddb = player:getcarddbbysid(sid)
		carddb:addcardbysid(sid,1,"test")
	end
	result = player.cardtablelib:updatecardtable(cardtable)
	assert(result.result == 0)
	--pprintf("normal_cardtablelib:%s",player.cardtablelib.normal_cardtablelib)
	assert(player.cardtablelib.normal_cardtablelib[1] ~= nil)
	cardtable.mode = 1
	assert(player.cardtablelib.nolimit_cardtablelib[1] == nil)
	player.cardtablelib:updatecardtable(cardtable)
	assert(player.cardtablelib.nolimit_cardtablelib[1] ~= nil)
	player.cardtablelib:delcardtable(1,1)
	assert(player.cardtablelib.nolimit_cardtablelib[1] == nil)
	pprintf("cardtable:%s",player.cardtablelib:save())
end

return test
