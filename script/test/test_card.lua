
require "script.playermgr"
require "script.war.aux"

local function test(pid)
	pid = assert(tonumber(pid),"Invalid pid:" .. tostring(pid))
	local player = playermgr.getplayer(pid)	
	if not player then
		return	
	end
	player.cardlib:clear()
	player.cardtablelib:clear()
	player.cardbaglib:clear()
	player:addchip(1000000,"test")

	player.cardlib:addcardbysid(141001,3)
	assert(player.cardlib:getcardnum(141001)==3)
	local card = player.cardlib:getcardbysid(141001)
	player.cardlib:decompose(card,1)
	assert(player.cardlib:getcardnum(141001)==2)
	player.cardlib:decompose(card,2)
	assert(player.cardlib:getcardbysid(141001)==nil)
	player.cardlib:compose(141001)
	assert(player.cardlib:getcardnum(141001)==1)
	player.cardlib:compose(141001)
	assert(player.cardlib:getcardnum(141001)==2)
	player.cardlib:delcardbysid(141001)
	assert(player.cardlib:getcardbysid(141001)==nil)
	local card = player.cardlib:newcard({
		sid = 141001,
		amount = 5,
	})
	player.cardlib:addcard(card,"test")
	assert(card == player.cardlib:getcard(card.id))
	assert(card:get("amount")==5)
	player.cardlib:delcard(card.id,"test")
	assert(player.cardlib:getcardbysid(card.sid)==nil)

	-- cardtable
	local cards = randomcard(30,2)
	local cardtable = {
		name = "cardtable_name",
		cards = cards,
	}
	player.cardtablelib:addcardtable("fight",cardtable,"test")
	assert(cardtable.id~=nil)
	assert(player.cardtablelib:getcardtable(cardtable.id)==cardtable)
	assert(cardtable.pos==1)
	player.cardtablelib:updatecardtable(cardtable.id,{
		name = "newname",
		cards = {},
	})
	assert(player.cardtablelib:getcardtable(cardtable.id)==cardtable)
	assert(cardtable.name == "newname")
	assert(next(cardtable.cards)==nil)
	player.cardtablelib:delcardtable(cardtable.id,"test")
	assert(player.cardtablelib:getcardtable(cardtable.id)==nil)

	-- cardbag
	player.cardbaglib:addcardbag(1000,5)
	assert(player.cardbaglib:getcardbagnum(1000)==5)
	player.cardbaglib:removecardbag(1000,3)
	assert(player.cardbaglib:getcardbagnum(1000)==2)
	player.cardbaglib:addcardbag(1000,2)
	assert(player.cardbaglib:getcardbagnum(1000)==4)
	local cardbag = player.cardbaglib:newcardbag({
		sid = 1001,
		amount = 3,
	})
	player.cardbaglib:add(cardbag)
	assert(cardbag.id ~= nil)
	assert(player.cardbaglib:get(cardbag.id)==cardbag)
	assert(player.cardbaglib:getcardbagnum(cardbag.sid) == 3)
	assert(player.cardbaglib.len == 2)
	player.cardbaglib:clear()
	assert(player.cardbaglib.len == 0)
end

return test
