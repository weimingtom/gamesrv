
cresume = class("cresume",cdatabaseable,csaveobj)

function cresume:init(pid)
	self.flag = "cresume"
	cdatabaseable.init(self,{
		pid = pid,
		flag = self.flag,
	})
	csaveobj.init(self,{
		pid = pid,
		flag = self.flag
	})
	self.pid_ref = {}
	self.srvname_ref = {}
	self.data = {}
	if not cserver.isresumesrv() then
		self.nosavetodatabase = true
	end
	self:autosave()
end

function cresume:load(data)
	if not data or not next(data) then
		return
	end
	self.data = data
end

function cresume:save()
	return self.data
end

function cresume:loadfromdatabase()
	local data
	if self.loadstate == "unload" then
		self.loadstate = "loading"
		if cserver.isresumesrv() then
			local db = dbmgr.getdb()
			data = db:get(db:key("resume",self.pid))
		else
			data = cluster.call("resumesrv","resumemgr","query",self.pid,"*")
		end
		if not data or not next(data) then
			self:onloadnull()
		else
			self:load(data)
		end
		self.loadstate = "loaded"
	end
end

function cresume:savetodatabase()
	if self.nosavetodatabase then
		return
	end
	if self.loadnull then
		return
	end
	if self.loadstate == "loaded" then
		if self:updated() then
			local data = self:save()
			local db = dbmgr.getdb()
			db:set(db:key("resume",self.pid),data)
		end
	end
end

function cresume:deletefromdatabase()
	if cserver.isresumesrv() then
		print("delresume",self.pid)
		db:del(db:key("resume",self.pid))
	end
end

function cresume:onloadnull()
	self.loadnull = true
	self:create()
end

function cresume:create(player)
	if cserver.isgamesrv() then
		print("resume:create",route.getsrvname(self.pid),skynet.getenv("srvname"),self.pid)
		if route.getsrvname(self.pid) ~= skynet.getenv("srvname") then
			logger.log("error","error",string.format("from resumesrv loadnull,srvname=%s pid=%s",route.getsrvname(self.pid),self.pid))
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
		self.data = player:packresume()
		self:sync(self:save())
	elseif cserver.isresumesrv() then
	end
end

function cresume:addref(pid)
	if type(pid) == "number" then
		self.pid_ref[pid] = (self.pid_ref[pid] or 0) + 1
	else
		local srvname = pid
		self.srvname_ref[srvname] = 1
	end
end

function cresume:delref(pid)
	if type(pid) == "number" then
		self.pid_ref[pid] = (self.pid_ref[pid] or 0) - 1
		if self.pid_ref[pid] <= 0 then
			self.pid_ref[pid] = nil
		end
	else
		local srvname = pid
		self.srvname_ref[srvname] = nil
	end
	if not next(self.pid_ref) and not next(self.srvname_ref) then
		friendmgr.delfrdblk(self.pid)
	end
end


function cresume:set(key,val,notsync)
	cdatabaseable.set(self,key,val)
	if not notsync then
		self:sync({[key] = val,})
	end
end

function cresume:sync(data)
	data.srvname = cserver.srvname
	for pid,_ in pairs(self.pid_ref) do
		if pid ~= self.pid then
			sendpackage(pid,"friend","sync",data)
		end
	end
	cluster.call("resumesrv","resumemgr","sync",self.pid,data)
end

return cresume
