
cfrienddb = class("cfrienddb",cdatabaseable)

function cfrienddb:init(pid)
	self.flag = "cfrienddb"
	cdatabaseable.init(self,{
		pid = pid,
		flag = self.flag,
	})
	self.frdlist = {}
	self.applyerlist = {}
	self.applyerlimit = 20
	self.frdlimit = 60
	self.data = {}
	self.thistemp = cthistemp.new{
		pid = pid,
		flag = self.flag,
	}
	self.timeattr = cattrcontainer.new{
		thistemp = self.thistemp,
	}
end

function cfrienddb:save()
	local data = {}
	data.frdlist = self.frdlist
	data.applyerlist = self.applyerlist
	data.data = self.data
	data.timeattr = self.timeattr:save()
	return data
end

function cfrienddb:load(data)
	if not data or not next(data) then
		return
	end
	self.frdlist = data.frdlist
	self.applyerlist = data.applyerlist
	self.data = data.data
	self.timeattr:load(data.timeattr)
	self:onload()
end

function cfrienddb:clear()
	self.frdlist = {}
	self.applyerlist = {}
	self.data = {}
	self.timeattr:clear()
end

function cfrienddb:oncreate(player)
end

function cfrienddb:onload()
	for pos,pid in ipairs(self.frdlist) do
		local frdblk = self:getfrdblk(pid)
		if frdblk.loadnull then
			logger.log("info","friend",string.format("delfrdlist(onload),pid=%d",pid))
			table.remove(self.frdlist,pos)
			friendmgr.delfrdblk(pid)
		end
	end
	for pos,pid in ipairs(self.applyerlist) do
		local frdblk = self:getfrdblk(pid)
		if frdblk.loadnull then
			logger.log("info","friend",string.format("delapplyerlist(onload),pid=%d",pid))
			table.remove(self.applyerlist,pos)
			friendmgr.delfrdblk(pid)
		end
	end

end

function cfrienddb:onlogin(player)
	local frdblk = self:getfrdblk(self.pid)
	frdblk:addref(self.pid)
	frdblk:set("online",true)
	for _,pid in ipairs(self.frdlist) do
		frdblk = self:getfrdblk(pid)
		frdblk:addref(self.pid)
		net.friend.sync(self.pid,frdblk:save())
	end
	local frdcnt = self:query("frdcnt",0)
	local frdlist = self.frdlist
	local new_frdlist
	if #self.frdlist > frdcnt then
		frdlist = slice(self.frdlist,1,frdcnt)
		new_frdlist = slice(frdcnt+1,#self.frdlist)
	end
	net.friend.addlist(self.pid,"friend",frdlist)
	if new_frdlist then
		net.friend.addlist(self.pid,"friend",new_frdlist,true)
	end
	for _,pid in ipairs(self.applyerlist) do
		frdblk = self.getfrdblk(pid)
		frdblk:addref(self.pid)
		net.friend.sync(self.pid,frdblk:save())
	end
	local applyercnt = self:query("applyercnt",0)
	local applyerlist = self.applyerlist
	local new_applyerlist
	if #self.applyerlist > applyercnt then
		applyerlist = slice(1,applyercnt)
		new_applyerlist = slice(applyercnt+1,#self.applyerlist)
	end
	net.friend.addlist(self.pid,"applyer",applyerlist)
	if new_applyerlist then
		net.friend.addlist(self.pid,"applyer",new_applyerlist,true)
	end
	local toapplylist = self.thistemp:query("toapplylist")
	if toapplylist then
		net.friend.addlist(self.pid,"toapply",toapplylist)
	end
end

function cfrienddb:onlogoff(player)
	local frdblk = self:getfrdblk(self.pid)
	frdblk:delref(self.pid)
	frdblk:set("online",false)
	for _,pid in ipairs(self.frdlist) do
		frdblk = self:getfrdblk(pid)
		frdblk:delref(self.pid)
	end
	for _,pid in ipairs(self.applyerlist) do
		frdblk = self:getfrdblk()
		frdblk:delref(self.pid)
	end
	self:set("applyercnt",#self.applyerlist)
	self:set("frdcnt",#self.frdlist)
end

function cfrienddb:getfrdblk(pid)
	return resumemgr.getresume(pid)
end

function cfrienddb:addapplyer(pid)
	if #self.applyerlist >= self:getapplyerlimit() then
		self:delapplyer(self.applyerlist[1])
	end
	local pos = findintable(self.applyerlist,pid)
	if pos then
		return
	end
	pos = findintable(self.frdlist,pid)
	if pos then
		return
	end
	logger.log("info","friend",string.format("#%d addapplyer,pid=%d",self.pid,pid))
	table.insert(self.applyerlist,pid)
	local frdblk = self:getfrdblk(pid)
	frdblk:addref(self.pid)
	net.friend.sync(self.pid,frdblk:save())
	net.friend.addlist(self.pid,"applyer",pid,true)
end

function cfrienddb:delapplyer(pid)
	logger.log("info","friend",string.format("#%d delapplyer,pid=%d",self.pid,pid))
	local pos = findintable(self.applyerlist,pid)
	if not pos then
	else
		table.remove(self.applyerlist,pos)
		local frdblk = self:getfrdblk(pid)
		frdblk:delref(self.pid)
	end
	net.friend.dellist(self.pid,"applyer",pid)
end

function cfrienddb:addfriend(pid)
	logger.log("info","friend",string.format("#%d addfriend %d",self.pid,pid))
	table.insert(self.frdlist,pid)
	local frdblk = self:getfrdblk(pid)
	frdblk:addref(self.pid)
	net.friend.sync(self.pid,frdblk:save())
	net.friend.addlist(self.pid,"friend",pid,true)
end

function cfrienddb:delfriend(pid)
	local ret
	local pos = findintable(self.frdlist,pid)
	if not pos then
		ret = false
	else
		logger.log("info","friend",string.format("#%d delfriend %d",self.pid,pid))
		table.remove(self.frdlist,pos)
		local frdblk = self:getfrdblk(pid)
		frdblk:delref(self.pid)
		ret = true
	end
	net.friend.dellist(self.pid,"friend",pid)	
	return ret
end


function cfrienddb:req_delfriend(pid)
	if not self:delfriend(pid) then
		return
	end
	local srvname = route.getsrvname(pid)
	if srvname == cserver.srvname then
		local target = playermgr.getplayer(pid)
		if not target then
			target = playermgr.loadofflineplayer(pid,"friend")
		end
		target.frienddb:delfriend(self.pid)
	else
		cluster.call(srvname,"playermethod",pid,"frienddb:delfriend",player.pid)
	end
end

function cfrienddb:apply_addfriend(pid)
	local toapplylist,exceedtime = self.thistemp:query("toapplylist",{})
	local pos = findintable(toapplylist,pid)
	if pos then
		net.msg.notify(self.pid,"您的申请已经发出")
		return
	end
	logger.log("info","friend",string.format("#%d apply_addfriend %d",self.pid,pid))
	table.insert(toapplylist,pid)
	self.thistemp:set("toapplylist",toapplylist,300)
	net.friend.addlist(self.pid,"toapply",pid,true)
	local srvname = route.getsrvname(pid)
	if srvname == cserver.srvname then
		local target = playermgr.getplayer(pid)
		if target then
			target.frienddb:addapplyer(self.pid)
		else
			target = playermgr.loadofflineplayer(pid,"friend")
			target.frienddb:addapplyer(self.pid)
		end
	else
		cluster.call(srvname,"playermethod",pid,"frienddb:addapplyer",self.pid)
	end
	
end

function cfrienddb:agree_addfriend(pid)
	local pos = findintable(self.frdlist,pid)
	if pos then
		net.msg.notify(self.pid,"该玩家已经是你好友了")
		return
	end
	if #self.frdlist >= self:getfriendlimit() then
		net.msg.notify(self.pid,"好友个数已达上限")
		return
	end
	pos = findintable(self.applyerlist,pid)
	if not pos then
		net.msg.notify(self.pid,"该玩家未向你发起过申请")
		return
	end
	logger.log("info","friend",string.format("#%d agree_addfriend %d",self.pid,pid))
	self:delapplyer(pid)
	self:addfriend(pid)
	local srvname = route.getsrvname(pid)
	if not srvname then
		net.msg.notify(self.pid,"该玩家不存在")
		return
	end
	if srvname == cserver.srvname then
		local target = playermgr.getplayer(pid)
		if target then
			target.frienddb:addfriend(self.pid)
		else
			target = playermgr.loadofflineplayer(pid,"friend")
			target.frienddb:addfriend(self.pid)
		end
	else
		cluster.call(srvname,"playermethod",pid,"frienddb:addfriend",self.pid)
	end

end

function cfrienddb:reject_addfriend(pid)
	logger.log("info","friend",string.format("#%d reject_addfriend %d",self.pid,pid))
	self:delapplyer(pid)
end

function cfrienddb:sendmsg(pid,msg)
	local frdblk = self:getfrdblk(pid)
	-- 不允许发送离线消息
	if not frdblk:query("online") then
		return
	end
	logger.log("debug","friend",string.format("#%d sendmsg to %d,msg=%s",self.pid,pid,msg))
	local srvname = route.getsrvname(pid)
	if srvname == cserver.srvname then
		net.friend.addmsgs(pid,self.pid,msg)
	else
		cluster.call(srvname,"modmethod","net.friend.addmsgs",pid,self.pid,msg)
	end
end

-- getter
function cfrienddb:getfriendlimit()
	return self.frdlimit + self:query("extfrdlimit",0)
end

function cfrienddb:getapplyerlimit()
	return self.applyerlimit
end

return cfrienddb
