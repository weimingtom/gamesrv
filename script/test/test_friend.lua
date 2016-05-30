
require "script.playermgr"

local function test(pid1,pid2)
	local player1 = playermgr.getplayer(pid1)
	local player2 = playermgr.getplayer(pid2)
	player1.frienddb:clear()
	player2.frienddb:clear()
	player1.frienddb:apply_addfriend(pid2)
	local pos = table.find(player2.frienddb.applyerlist,pid1)
	assert(pos)
	player2.frienddb:reject_addfriend(pid1)
	pos = table.find(player2.frienddb.applyerlist,pid1)
	assert(pos==nil)
	player1.frienddb:apply_addfriend(pid2)	
	pos = table.find(player2.frienddb.applyerlist,pid1)
	assert(pos==nil)
	player1.frienddb.thistemp:clear()
	player1.frienddb:apply_addfriend(pid2)
	player2.frienddb:agree_addfriend(pid1)
	pos = table.find(player1.frienddb.frdlist,pid2)
	assert(pos)
	pos = table.find(player2.frienddb.frdlist,pid1)
	assert(pos)
	player1.frienddb:sendmsg(pid2,"hello,world")
	player2.frienddb:req_delfriend(pid1)
	pos = table.find(player1.frienddb.frdlist,pid2)
	assert(pos==nil)
	pos = table.find(player2.frienddb.frdlist,pid1)	
	assert(pos==nil)
end

return test
