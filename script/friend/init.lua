
require "script.globalmgr"
require "script.friend.friendmgr"
require "script.cluster.clustermgr"
require "script.attrblock.saveobj"
require "script.logger"

cfriend = class("cfriend",cdatabaseable,csaveobj)

function cfriend:init(pid)
	self.flag = "cfriend"
	cdatabaseable.init(self,{
		pid = pid,
		flag = self.flag,
	})
	csaveobj.init(self,{
		pid = pid,
		flag = self.flag
	})
	self.refs = {}
	self.data = {}
	if not cserver.isfrdsrv() then
		self.nosavetodatabase = true
	end
	self:autosave()
end

function cfriend:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data
end

function cfriend:save()
	return self.data
end

function cfriend:loadfromdatabase()
	local data
	if self.loadstate == "unload" then
		self.loadstate = "loading"
		if cserver.isfrdsrv() then
			data = db:get(db:key("friend",self.pid))
		else
			data = cluster.call("frdsrv","friendmgr","query",self.pid,"*")
		end
		if not data or not next(data) then
			self:onloadnull()
		else
			self:load(data)
		end
		self.loadstate = "loaded"
	end
end

function cfriend:savetodatabase()
	if self.nosavetodatabase then
		return
	end
	if self.loadnull then
		return
	end
	if self.loadstate == "loaded" then
		if self:updated() then
			local data = self:save()
			db:set(db:key("friend",self.pid),data)
		end
	end
end

function cfriend:deletefromdatabase()
	if cserver.isfrdsrv() then
		print("delfriendblk",self.pid)
		db:del(db:key("friend",self.pid))
	end
end

function cfriend:onloadnull()
	self.loadnull = true
	self:create()
end

function cfriend:create(player)
	if cserver.isgamesrv() then
		print("friend:create",route.getsrvname(self.pid),skynet.getenv("srvname"),self.pid)
		if route.getsrvname(self.pid) ~= skynet.getenv("srvname") then
			logger.log("error","err",string.format("from frdsrv loadnull,srvname=%s pid=%s",route.getsrvname(self.pid),self.pid))
			return
		end
		self.loadnull = nil
		if not player then
			player = playermgr.getplayer(self.pid)
			if player then
			else
				player = playermgr.loadofflineplayer(self.pid)
			end
		end
		self.data = {
			lv = player:query("lv"),
			name = player:query("name"),
			roletype = player:query("roletype"),
			srvname = cserver.srvname,
			viplv = player:query("viplv"),
		}
		self:sync(self:save())
	elseif cserver.isfrdsrv() then
	end
end

-- 为了简化操作，ref只统计谁引用过我，而不记录引用次数，这样对于玩家，可以在上线，增加好友/申请者时增加引用，下线，删除好友/申请者时减少引用
function cfriend:addref(arg)
	if (type(arg) ~= "number" and not  clustermgr.srvlist[arg]) then
		error("addref invalid arg:" .. tostring(arg))
	end
	self.refs[arg] = 1
end

function cfriend:delref(arg)
	self.refs[arg] = nil
	if not next(self.refs) then
		friendmgr.delfrdblk(self.pid)
	end
end


function cfriend:set(key,val,notsync)
	cdatabaseable.set(self,key,val)
	if not notsync then
		self:sync({[key] = val,})
	end
end

function cfriend:sync(data)
	for pid,_ in pairs(self.refs) do
		if pid ~= self.pid then
			sendpackage(pid,"friend","sync",data)
		end
	end
	cluster.call("frdsrv","friendmgr","sync",self.pid,data)
end

-- merge server need
function cfriend:updatepid(newpid)
	local oldpid = self.pid
	for pid,_ in pairs(self.refs) do
		local player = playermgr.getplayer(pid)
		if player then
			if findintable(player.frienddb.frdlist,oldpid) then
				player.frienddb:delfriend(oldpid)
				player.frienddb:addfriend(newpid)
			end
			if findintable(player.frienddb.applyerlist,oldpid) then
				player.frienddb:delapplyer(oldpid)
				player.frienddb:addapplyer(newpid)
			end
		end
	end
	cluster.call("frdsrv","friendmgr","updatepid",oldpid,newpid)
end

return cfriend
