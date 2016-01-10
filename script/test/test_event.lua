local function test(pid)
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	local reason = "test.event"
	player:addgold(-player.gold,reason)
	player.achievedb:clear()
	local achieveid1,achieveid2,achieveid3 = 1,2,3
	local target1 = data_achievement[achieveid1].target
	local target2 = data_achievement[achieveid2].target
	local target3 = data_achievement[achieveid3].target
	local achieve1 = player.achievedb:getachieve(achieveid1)
	local achieve2 = player.achievedb:getachieve(achieveid2)
	local achieve3 = player.achievedb:getachieve(achieveid3)
	assert(achieve1==nil)
	assert(achieve2==nil)
	assert(achieve3==nil)
	player:addgold(target1-1,reason)
	local achieve1 = player.achievedb:getachieve(achieveid1)
	assert(achieve1)
	print("achieve1.progress",achieve1.progress,target1)
	assert(achieve1.progress==target1-1)
	local achieve2 = player.achievedb:getachieve(achieveid2)
	assert(achieve2)
	assert(achieve2.progress==target1-1)
	local achieve3 = player.achievedb:getachieve(achieveid3)
	assert(achieve3)
	assert(achieve3.progress==target1-1)
	player:addgold(target2-target1,reason)
	local achieve1 = player.achievedb:getachieve(achieveid1)
	assert(achieve1.progress==target1)
	local achieve2 = player.achievedb:getachieve(achieveid2)
	assert(achieve2.progress==target2-1)
	local achieve3 = player.achievedb:getachieve(achieveid3)
	assert(achieve3.progress==target2-1)
	player:addgold(target3-target2+1,reason)
	local achieve1 = player.achievedb:getachieve(achieveid1)
	assert(achieve1.progress==target1)
	local achieve2 = player.achievedb:getachieve(achieveid2)
	assert(achieve2.progress==target2)
	local achieve3 = player.achievedb:getachieve(achieveid3)
	assert(achieve3.progress==target3)
	player:addgold(1,reason)
	local achieve1 = player.achievedb:getachieve(achieveid1)
	assert(achieve1.progress==target1)
	local achieve2 = player.achievedb:getachieve(achieveid2)
	assert(achieve2.progress==target2)
	local achieve3 = player.achievedb:getachieve(achieveid3)
	assert(achieve3.progress==target3)
	assert(player.gold==target3+1)
end

return test
