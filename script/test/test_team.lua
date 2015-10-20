local function test(pid1,pid2,pid3)
	print(pid1,pid2,pid3,type(pid1))
	local player1 = playermgr.getplayer(pid1)
	local player2 = playermgr.getplayer(pid2)
	local player3 = playermgr.getplayer(pid3)
	player2:enterscene(player1.sceneid,player1.pos)
	player3:enterscene(player1.sceneid,player1.pos)
	local request = net.team.REQUEST
	-- clear
	request.quitteam(player1,{})	
	request.quitteam(player2,{})
	request.quitteam(player3,{})

	request.createteam(player1,{target=1,stage=1})
	local teamid = player1.teamid
	assert(teamid)
	local team = teammgr:getteam(teamid)
	assert(team)
	assert(team.captain == pid1)
	-- ignore repeat createteam
	request.createteam(player1,{target=2,stage=2})
	local teamid = player1.teamid
	assert(teamid)
	local team = teammgr:getteam(teamid)
	assert(team)
	assert(team.captain == pid1)
	assert(team.target==1)
	assert(team.stage==1)
	request.apply_jointeam(player2,{teamid=teamid})	
	assert(#team.applyers==1)
	assert(team.applyers[1].pid == pid2)
	-- ignore repeat addapplyer
	request.apply_jointeam(player2,{teamid=teamid})
	assert(#team.applyers==1)
	
	request.invite_jointeam(player2,{pid=pid3})
	net.msg.REQUEST.onmessagebox(player3,{
		id=messagebox.id,
		buttonid = 1, -- agree
	})	
	assert(#team.applyers==2)
	assert(team.applyers[2].pid==pid3)
	request.agree_jointeam(player1,{pid=pid2})
	assert(#team.applyers==1)
	assert(team.follow[pid2]==true)
	request.agree_jointeam(player1,{pid=pid3})
	assert(#team.applyers==0)
	assert(team.follow[pid3]==true)
	request.leaveteam(player2)
	assert(team.follow[pid2]==nil)
	assert(team.leave[pid2]==true)
	player2:setpos({x=player2.x+5,y=player2.y+5,dir=player2.dir})
	request.backteam(player2)
	assert(team.follow[pid2]==true)
	assert(team.leave[pid2]==nil)
	assert(player2.sceneid==player1.sceneid)
	assert(equal(player2.pos,player1.pos))
	request.changecaptain(player1,{pid=pid2})
	assert(team.captain==pid2)
	assert(team.follow[pid1]==true)
	-- non-captain cann't changecaptain
	request.changecaptain(player1,{pid=pid3})
	assert(team.captain==pid2)
	
	-- non-captain cann't changetarget
	request.changetarget(player1,{target=2,stage=2})
	assert(team.target==1)
	assert(team.stage==1)
	request.changetarget(player2,{target=2,stage=2})
	assert(team.target==2)
	assert(team.stage==2)
	--
	request.syncteam(player,{})
	request.openui_team(player,{})
end

return test
