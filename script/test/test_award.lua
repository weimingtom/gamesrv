
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
	--print(player.gold)
	assert(player.gold==1120) -- 110 + (player.lv*10+1000)
	rewards = award.getaward(rewards)
	local mailid = mailmgr.sendmail(pid,{
		srcid = SYSTEM_MAIL,
		author = "系统",
		title = "test",
		content = "formula",
		attach = rewards,
	})
	player:setlv(2,reason)
	local mailbox = mailmgr.getmailbox(pid)
	mailbox:getattach(mailid)
	assert(player.gold==2140) -- 1120 + 1020
end

return test
