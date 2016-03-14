local skynet = require "skynet"

require "script.playermgr"
require "script.net.war"
require "script.war.aux"

local function test(pid1,pid2,race,num)
	local player1 = playermgr.getplayer(pid1)
	local player2 = playermgr.getplayer(pid2)
	player1.cardlib:clear()
	player1.cardtablelib:clear()
	player2.cardlib:clear()
	player2.cardtablelib:clear()
	local cardsids = {}
	race = race or RACE_GOLDEN
	num = num or 30
	local name = string.format("种族:%d",race)
	local cardsids = getcards(name,function (cardcls)
		return cardcls.race == race
	end)
	for i,cardsid in ipairs(cardsids) do
		player1.cardlib:addcardbysid(cardsid,1,"test")
		player2.cardlib:addcardbysid(cardsid,1,"test")
	end
	local mode = CARDTABLE_MODE_NORMAL
	local cardtable1 = {
		race = race,
		name = "test",
		cards = cardsids,
	}
	local cardtable2 = {
		race = race,
		name = "test",
		cards = cardsids,
	}

	pprintf("cardtable:%s",cardtable1)
	player1.cardtablelib:addcardtable("fight",cardtable1,"test")
	player2.cardtablelib:addcardtable("fight",cardtable2,"test")
	netwar.REQUEST.unsearch_opponent(player1,{
		type = "fight",
	})
	netwar.REQUEST.unsearch_opponent(player2,{
		type = "fight",
	})

	netwar.REQUEST.selectcardtable(player1,{
		type = "fight",
		cardtableid = cardtable1.id,
	})
	netwar.REQUEST.selectcardtable(player2,{
		type = "fight",
		cardtableid = cardtable2.id,
	})
	netwar.REQUEST.search_opponent(player1,{
		type = "fight",
	})
	netwar.REQUEST.search_opponent(player2,{
		type = "fight",
	})
	skynet.sleep(200)
	local warid = assert(player1:query("fight.warid"))
	local warsrvname = assert(player1:query("fight.warsrvname"))
	print("startwar",warsrvname,pid1,pid2,warid)
	cluster.call(warsrvname,"modmethod","war.ai",".inject_ai",warid,pid1)
	cluster.call(warsrvname,"modmethod","war.ai",".inject_ai",warid,pid2)
	netwar.REQUEST.confirm_handcard(player1,{
		ids = {},
	})	
	netwar.REQUEST.confirm_handcard(player2,{
		ids = {},
	})	

end

return test

