
local function test(pid)
	local player = playermgr.getplayer(pid)
	local reason = "test"
	player:addgold(-player.gold,reason)
	player:setlv(1,reason)
	local rewards = {{type=1,value={[1]=1000000}}}
	doaward("player",pid,rewards,reason,true)
	assert(player.gold==10)
	local rewards = {{type=2,value={[2]=1}}}
	doaward("player",pid,rewards,reason,true)
	assert(player.gold==110)
	local rewards = {{type=2,value={[5]=1}}}
	doaward("player",pid,rewards,reason,true)
	assert(player.gold==220) -- 110 + (player.lv*10+100)
	mailmgr.sendmail(pid,{
		srcid = SYSTEM_MAIL,
		author = "系统",
		title = "test",
		content = "formula",
		attach = rewards,
	})

end

return test
