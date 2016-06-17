
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
	local server = globalmgr.server
	if not server:isopen("friend") then
		return
	end
	resumemgr.oncreate(player)
end

function cfrienddb:onload()
	for pos,pid in ipairs(self.frdlist) do
		local frdblk = self:getfrdblk(pid)
		if not frdblk then
			logger.log("error","friend",string.format("[delfrdlist onload] pid=%d",pid))
			table.remove(self.frdlist,pos)
		end
	end
	for pos,pid in ipairs(self.applyerlist) do
		local frdblk = self:getfrdblk(pid)
		if not frdblk then
			logger.log("error","friend",string.format("[delapplyerlist onload] pid=%d",pid))
			table.remove(self.applyerlist,pos)
		end
	end
end


function cfrienddb:onlogin(player)
	local server = globalmgr.server
	if not server:isopen("friend") then
		return
	end
	resumemgr.onlogin(player) -- keep before
	local frdblk = self:getfrdblk(self.pid)
	frdblk:addref(self.pid)
	for _,pid in ipairs(self.frdlist) do
		frdblk = self:getfrdblk(pid)
		frdblk:addref(self.pid)
		net.friend.S2C.sync(self.pid,self:pack_frdblk(frdblk))
	end
	local frdcnt = self:query("frdcnt",0)
	local frdlist = self.frdlist
	local new_frdlist
	if #self.frdlist > frdcnt then
		frdlist = table.slice(self.frdlist,1,frdcnt)
		new_frdlist = table.slice(frdcnt+1,#self.frdlist)
	end
	net.friend.S2C.addlist(self.pid,"friend",frdlist)
	if new_frdlist then
		net.friend.S2C.addlist(self.pid,"friend",new_frdlist,true)
	end
	for _,pid in ipairs(self.applyerlist) do
		frdblk = self.getfrdblk(pid)
		frdblk:addref(self.pid)
		net.friend.S2C.sync(self.pid,self:pack_frdblk(frdblk))
	end
	local applyercnt = self:query("applyercnt",0)
	local applyerlist = self.applyerlist
	local new_applyerlist
	if #self.applyerlist > applyercnt then
		applyerlist = table.slice(1,applyercnt)
		new_applyerlist = table.slice(applyercnt+1,#self.applyerlist)
	end
	net.friend.S2C.addlist(self.pid,"applyer",applyerlist)
	if new_applyerlist then
		net.friend.S2C.addlist(self.pid,"applyer",new_applyerlist,true)
	end
	local toapplylist = self.thistemp:query("toapplylist")
	if toapplylist then
		net.friend.S2C.addlist(self.pid,"toapply",toapplylist)
	end
end

function cfrienddb:onlogoff(player)
	local server = globalmgr.server
	if not server:isopen("friend") then
		return
	end
	resumemgr.onlogoff(player) -- keep before
	local frdblk = self:getfrdblk(self.pid)
	frdblk:delref(self.pid)
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

function cfrienddb:delfrdblk(pid)
	return resumemgr.delresume(pid)
end

function cfrienddb:pack_frdblk(frdblk)
	return {
		pid = frdblk.pid,
		name = frdblk:query("name"),
		lv = frdblk:query("lv"),
		roletype = frdblk:query("roletype"),
		srvname = frdblk:query("srvname"),
	}
end


function cfrienddb:addapplyer(pid)
	if #self.applyerlist >= self:getapplyerlimit() then
		self:delapplyer(self.applyerlist[1])
	end
	local pos = table.find(self.applyerlist,pid)
	if pos then
		return
	end
	pos = table.find(self.frdlist,pid)
	if pos then
		return
	end
	logger.log("info","friend",string.format("[addapplyer] owner=%s pid=%d",self.pid,pid))
	table.insert(self.applyerlist,pid)
	local frdblk = self:getfrdblk(pid)
	frdblk:addref(self.pid)
	net.friend.S2C.sync(self.pid,self:pack_frdblk(frdblk))
	net.friend.S2C.addlist(self.pid,"applyer",pid,true)
end

function cfrienddb:delapplyer(pid)
	logger.log("info","friend",string.format("[delapplyer] owner=%s pid=%d",self.pid,pid))
	local pos = table.find(self.applyerlist,pid)
	if not pos then
	else
		table.remove(self.applyerlist,pos)
		local frdblk = self:getfrdblk(pid)
		frdblk:delref(self.pid)
	end
	net.friend.S2C.dellist(self.pid,"applyer",pid)
end

function cfrienddb:addfriend(pid)
	local pos = table.find(self.frdlist,pid)
	if pos then
		return
	end
	logger.log("info","friend",string.format("[addfriend] owner=%s pid=%d",self.pid,pid))
	table.insert(self.frdlist,pid)
	local frdblk = self:getfrdblk(pid)
	frdblk:addref(self.pid)
	net.friend.S2C.sync(self.pid,self:pack_frdblk(frdblk))
	net.friend.S2C.addlist(self.pid,"friend",pid,true)
end

function cfrienddb:delfriend(pid)
	local ret
	local pos = table.find(self.frdlist,pid)
	if not pos then
		ret = false
	else
		logger.log("info","friend",string.format("[delfriend] owner=%s pid=%d",self.pid,pid))
		table.remove(self.frdlist,pos)
		local frdblk = self:getfrdblk(pid)
		frdblk:delref(self.pid)
		ret = true
	end
	net.friend.S2C.dellist(self.pid,"friend",pid)	
	return ret
end


function cfrienddb:req_delfriend(pid)
	if not self:delfriend(pid) then
		return
	end
	local srvname = route.getsrvname(pid)
	if srvname == cserver.getsrvname() then
		local target = playermgr.getplayer(pid)
		if not target then
			target = playermgr.loadofflineplayer(pid)
		end
		if target then
			target.frienddb:delfriend(self.pid)
		end
	else
		rpc.call(srvname,"playermethod",self.pid,"frienddb:delfriend",pid)
	end
end

function cfrienddb:apply_addfriend(pid)
	local toapplylist,exceedtime = self.thistemp:query("toapplylist",{})
	local pos = table.find(toapplylist,pid)
	if pos then
		net.msg.S2C.notify(self.pid,"您的申请已经发出")
		return
	end
	logger.log("info","friend",string.format("[apply_addfriend] owner=%s pid=%d",self.pid,pid))
	table.insert(toapplylist,pid)
	self.thistemp:set("toapplylist",toapplylist,300)
	net.friend.S2C.addlist(self.pid,"toapply",pid,true)
	local srvname = route.getsrvname(pid)
	if srvname == cserver.getsrvname() then
		local target = playermgr.getplayer(pid)
		if not target then
			target = playermgr.loadofflineplayer(pid)
		end
		if target then
			target.frienddb:addapplyer(self.pid)
		end
	else
		rpc.call(srvname,"playermethod",pid,"frienddb:addapplyer",self.pid)
	end
	
end

function cfrienddb:agree_addfriend(pid)
	local pos = table.find(self.frdlist,pid)
	if pos then
		net.msg.S2C.notify(self.pid,"该玩家已经是你好友了")
		return
	end
	if #self.frdlist >= self:getfriendlimit() then
		net.msg.S2C.notify(self.pid,"好友个数已达上限")
		return
	end
	pos = table.find(self.applyerlist,pid)
	if not pos then
		net.msg.S2C.notify(self.pid,"该玩家未向你发起过申请")
		return
	end
	logger.log("info","friend",string.format("[agree_addfriend] owner=%s pid=%d",self.pid,pid))
	self:delapplyer(pid)
	self:addfriend(pid)
	local srvname = route.getsrvname(pid)
	if not srvname then
		net.msg.S2C.notify(self.pid,"该玩家不存在")
		return
	end
	if srvname == cserver.getsrvname() then
		local target = playermgr.getplayer(pid)
		if not target then
			target = playermgr.loadofflineplayer(pid)
		end
		if target then
			target.frienddb:addfriend(self.pid)
		end
	else
		rpc.call(srvname,"playermethod",pid,"frienddb:addfriend",self.pid)
	end

end

function cfrienddb:reject_addfriend(pid)
	logger.log("info","friend",string.format("[reject_addfriend] owner=%s pid=%d",self.pid,pid))
	self:delapplyer(pid)
end

function cfrienddb:sendmsg(pid,msg)
	local frdblk = self:getfrdblk(pid)
	-- 不允许发送离线消息
	if not frdblk:query("online") then
		return
	end
	logger.log("debug","friend",string.format("[sendmsg] owner=%s pid=%d msg=%s",self.pid,pid,msg))
	local srvname = route.getsrvname(pid)
	if srvname == cserver.getsrvname() then
		net.friend.S2C.addmsgs(pid,self.pid,msg)
	else
		rpc.call(srvname,"modmethod","net.friend",".addmsgs",pid,self.pid,msg)
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
