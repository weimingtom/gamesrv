local function test()
	local vote = votemgr:newvote({
		exceedtime = os.time() + 300,
		member_vote = {
			[10001] = 1,
			[10002] = 2,
			[10003] = 3,
		},
		callback = function (vote,state)
			print("state:",state)
			print(table.dump(vote))
		end
	})
	local typ = "testvote"
	votemgr:addvote(typ,vote)
	local isok,errmsg = votemgr:voteto(typ,10001)
	assert(isok,errmsg)
	assert(not votemgr:voteto(typ,10001))
	local vote = votemgr:getvotebypid(typ,10001)
	assert(vote.candidate[cvotemgr.AGREE_VOTE][10001])
	local isok,errmsg = votemgr:cancel_voteto(typ,10001)
	assert(isok,errmsg)
	local isok = votemgr:cancel_voteto(typ,10001)
	assert(not isok)
	local vote = votemgr:getvotebypid(typ,10001)
	assert(not vote.candidate[cvotemgr.AGREE_VOTE][10001])
	votemgr:voteto(typ,10001)
	votemgr:voteto(typ,10002)
	local isok,errmsg = votemgr:quit_vote(typ,10002)
	assert(isok,errmsg)
	local isok = votemgr:quit_vote(typ,10002)
	assert(not isok)
	votemgr:voteto(typ,10003)
	local vote = votemgr:getvote(vote.id)
	assert(vote==nil)
end

return test
