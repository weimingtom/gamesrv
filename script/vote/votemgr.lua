cvotemgr = class("cvotemgr",{
	AGREE_VOTE = 0,
})

function cvotemgr:init()
	self.type_id_vote = {}
	self.type_pid_id = {}
	self.voteid = 0
	self:check_timeout()
end

function cvotemgr:gen_voteid()
	if self.voteid >= MAX_NUMBER then
		self.voteid = 0
	end
	self.voteid = self.voteid + 1
	return self.voteid
end

function cvotemgr:newvote(vote)
	assert(vote.member_vote)
	assert(vote.callback)
	local sum_vote = 0
	for _,votenum in pairs(vote.member_vote) do
		sum_vote = sum_vote + votenum
	end
	vote.pass_vote = vote.pass_vote or sum_vote
	vote.pass_vote = math.min(vote.pass_vote,sum_vote)
	vote.giveup_member = vote.giveup_member or {}
	vote.candidate = vote.candidate or {[cvotemgr.AGREE_VOTE] = {},}
	return vote
end

--/*
-- 新增投票
-- @param typ string/integer 投票类型
-- @param vote table  具体投票信息
-- @e.g
-- votemgr:addvote("罢免帮主",{
--		member_vote = {
--			[10001] = 3,  --10001玩家的投票占3票
--		},
--		candidate = {     -- 可选字段
--			[10001] = {},  -- 候选人10001的支持者
--		},
--		giveup_member = {  -- 弃权成员
--		}
--		allow_voteto_self = false, -- 手否允许投给自己
--		pass_vote = 10,	  -- 投票数达到一定值则终止投票
--		exceedtime = os.time() + 300, -- 过期时间
--		callback = function (vote,state)  -- 投票出结果后的回调函数
--		end,
-- })
--*/
function cvotemgr:addvote(typ,vote)
	if not self.type_id_vote[typ] then
		self.type_id_vote[typ] = {}
		self.type_pid_id[typ] = {}
	end
	local voteid = self:gen_voteid()
	vote.id = voteid
	vote.type = typ
	logger.log("info","vote",format("[addvote] type=%s id=%s vote=%s",typ,voteid,vote))
	self.type_id_vote[typ][voteid] = vote
	for pid,votenum in pairs(vote.member_vote) do
		self.type_pid_id[typ][pid] = voteid
	end
	xpcall(self.onaddvote,onerror,self,vote)
end

function cvotemgr:delvote(id,typ)
	if typ then
		return self:__delvote(id,typ)
	else
		for typ,_ in pairs(self.type_id_vote) do
			local vote = self:__delvote(id,typ)
			if vote then
				return vote
			end
		end
	end
end

function cvotemgr:__delvote(id,typ)
	local id_vote = self.type_id_vote[typ]
	if id_vote then
		local vote = id_vote[id]
		if vote then
			logger.log("info","vote",string.format("[delvote] type=%s id=%s",typ,id))
			xpcall(self.ondelvote,onerror,self,vote)
			id_vote[id] = nil
			for pid,_ in pairs(vote.member_vote) do
				self.type_pid_id[typ][pid] = nil
			end
			return vote
		end
	end
end

function cvotemgr:getvote(id,typ)
	if typ then
		return self:__getvote(id,typ)
	else
		for typ,_ in pairs(self.type_id_vote) do
			local vote = self:__getvote(id,typ)
			if vote then
				return vote
			end
		end
	end
end

function cvotemgr:__getvote(id,typ)
	local id_vote = self.type_id_vote[typ]
	if not id_vote then
		return
	end
	return id_vote[id]
end


function cvotemgr:getvotebypid(typ,pid)
	local id
	for k,pid_id in pairs(self.type_pid_id) do
		if k == typ then
			id = pid_id[pid]
			break
		end
	end
	if id then
		return self:__getvote(id,typ)
	end
end

function cvotemgr:isvoted(vote,pid)
	for topid,supporter in pairs(vote.candidate) do
		if supporter[pid] then
			return true,topid
		end
	end
	return false
end

function cvotemgr:isgiveup(vote,pid)
	for giveup_pid,_ in pairs(vote.giveup_member) do
		if giveup_pid == pid then
			return true
		end
	end
	return false
end

function cvotemgr:voteto(typ,pid,topid)
	topid = topid or cvotemgr.AGREE_VOTE
	local vote = self:getvotebypid(typ,pid)
	if not vote then
		return false,"未参与投票"
	end
	if not vote.member_vote[pid] then
		return false,"退出后无法继续投票"
	end
	if self:isgiveup(vote,pid) then
		return false,"弃权后无法继续投票"
	end
	if self:isvoted(vote,pid) then
		return false,"无法重复投票"
	end
	if not vote.allow_voteto_self and pid == topid then
		return false,"无法给自身投票"
	end
	local votenum = vote.member_vote[pid]
	if not vote.candidate[topid] then
		return false,"未知候选人"
	end
	vote.candidate[topid][pid] = true
	logger.log("info","vote",string.format("[voteto] type=%s pid=%s topid=%s votenum=%s",typ,pid,topid,votenum))
	if self:check_endvote(vote) then
		self:delvote(vote.id,typ)
	else
		xpcall(self.onupdatevote,onerror,self,vote)
	end
	return true
end

function cvotemgr:cancel_voteto(typ,pid)
	local vote = self:getvotebypid(typ,pid)
	if not vote then
		return false,"未参与投票"
	end
	local isvote,topid = self:isvoted(vote,pid)
	if not isvote then
		return false,"未投票过，无法取消"
	end
	local votenum = vote.member_vote[pid]
	logger.log("info","vote",string.format("[cancel_voteto] type=%s pid=%s topid=%s votenum=%s",typ,pid,topid,votenum))
	vote.candidate[topid][pid] = nil
	return true
end

function cvotemgr:giveup_vote(typ,pid)
	local vote = self:getvotebypid(typ,pid)
	if not vote then
		return false,"未参与投票"
	end
	if not vote.member_vote[pid] then
		return false,"退出后无法继续弃权"
	end
	if self:isgiveup(vote,pid) then
		return false,"弃权后无法继续弃权"
	end
	if self:isvoted(vote,pid) then
		return false,"已投过票了，弃权失效"
	end
	local votenum = vote.member_vote[pid]
	logger.log("info","vote",string.format("[giveup_vote] type=%s pid=%s votenum=%s",typ,pid,votenum))
	vote.giveup_member[pid] = true
	if self:check_endvote(vote) then
		self:delvote(vote.id,typ)
	else
		xpcall(self.onupdatevote,onerror,self,vote)
	end
	return true
end

function cvotemgr:quit_vote(typ,pid)
	local vote = self:getvotebypid(typ,pid)
	if not vote then
		return
	end
	logger.log("info","vote",string.format("[quit_vote] type=%s pid=%s",typ,pid))
	self:cancel_voteto(typ,pid)
	vote.member_vote[pid] = nil
	vote.giveup_member[pid] = nil
	local isvoted,topid = self:isvoted(vote,pid)
	if isvoted then
		vote.candidate[topid][pid] = nil
	end
	local sum_vote = 0
	for _,votenum in pairs(vote.member_vote) do
		sum_vote = sum_vote + votenum
	end
	vote.pass_vote = math.min(vote.pass_vote,sum_vote)
	self.type_pid_id[typ][pid] = nil
	if self:check_endvote(vote) then
		self:delvote(vote.id,typ)
	else
		xpcall(self.onupdatevote,onerror,self,vote)
	end
	return true
end

function cvotemgr:check_endvote(vote)
	local has_vote = 0
	for _,supporter in pairs(vote.candidate) do
		for pid,_ in pairs(supporter) do
			local votenum = vote.member_vote[pid]
			has_vote = has_vote + votenum
		end
	end
	if has_vote >= vote.pass_vote then
		vote.callback(vote,"pass")
		return true,"pass"
	end
	local giveup_vote = 0
	for pid,_ in pairs(vote.giveup_member) do
		local votenum = vote.member_vote[pid]
		giveup_vote = giveup_vote + votenum
	end
	local sum_vote = 0
	for _,votenum in pairs(vote.member_vote) do
		sum_vote = sum_vote + votenum
	end
	if sum_vote - giveup_vote < vote.pass_vote then
		vote.callback(vote,"unpass")
		return true,"unpass"
	end
	return false
end

function cvotemgr:check_timeout()
	timer.timeout("cvotemgr.check_timeout",10,functor(self.check_timeout,self))
	local now = os.time()
	for typ,id_vote in pairs(self.type_id_vote) do
		for id,vote in pairs(id_vote) do
			if vote.exceedtime and now >= vote.exceedtime then
				vote.callback(vote,"timeout")
				self:delvote(id,typ)
			end
		end
	end
end

function cvotemgr:onaddvote(vote)
	--print("onaddvote:",table.dump(vote))
end

function cvotemgr:ondelvote(vote)
	--print("ondelvote:",table.dump(vote))
end

function cvotemgr:onupdatevote(vote)
	--print("onupdatevote:",table.dump(vote))
end

return cvotemgr
