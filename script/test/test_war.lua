
require "script.playermgr"
require "script.net.war"

local function test(pid1,pid2)
	local func = require "script.test.test_card"	
	func(pid1)
	func(pid2)

	local player1 = playermgr.getplayer(pid1)
	local player2 =playermgr.getplayer(pid2)
	netwar.REQUEST.selectcardtable(player1,{
		type = "fight",
		cardtableid = 1,
	})
	netwar.REQUEST.selectcardtable(player2,{
		type = "fight",
		cardtableid = 1,
	})
	netwar.REQUEST.search_opponent(player1,{
		type = "fight",
	})
	netwar.REQUEST.search_opponent(player2,{
		type = "fight",
	})
		
end

return test
