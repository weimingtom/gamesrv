local skynet = require "skynet"

require "script.playermgr"
require "script.net.war"
require "script.war.aux"

local function test(pid1,pid2,race1,cardrace1,race2,cardrace2)
	local player1 = playermgr.getplayer(pid1)
	local player2 = playermgr.getplayer(pid2)
	player1.cardlib:clear()
	player1.cardtablelib:clear()
	player2.cardlib:clear()
	player2.cardtablelib:clear()
	local cardsids = {}
	local name = string.format("种族:%d",cardrace1)
	local cardsids1 = getcards(name,function (cardcls)
		return cardcls.race == cardrace1
	end)
	local name = string.format("种族:%d",cardrace2)
	local cardsids2 = getcards(name,function (cardcls)
		return cardcls.race == cardrace2
	end)
	for i,cardsid in ipairs(cardsids1) do
		player1.cardlib:addcardbysid(cardsid,1,"test")
	end
	for i,cardsid in ipairs(cardsids2) do
		player2.cardlib:addcardbysid(cardsid,1,"test")
	end
	local mode = CARDTABLE_MODE_NORMAL
	local cardtable1 = {
		race = race1,
		name = "test",
		cards = cardsids1,
	}
	local cardtable2 = {
		race = race2,
		name = "test",
		cards = cardsids2,
	}

	pprintf("pid=%s cardtable=%s",pid1,cardtable1)
	pprintf("pid=%s cardtable=%s",pid2,cardtable2)

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

