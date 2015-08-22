
require "script.war.warobj"
require "script.logger"
require "script.war.aux"

--- 1. player ready
--- 2. startwar
--- 3. loopround
--- 4. endwar

__warid = __warid or 0

cwar = class("cwar",cdatabaseable)

function cwar:init(profile1,profile2)
	__warid = __warid + 1
	cdatabaseable.init(self,{
		pid = 0,
		flag = "cwar",
	})
	self.data = {}
	self.warid = __warid
	self.attacker = cwarobj.new(profile1,self.warid)
	self.defenser = cwarobj.new(profile2,self.warid)
	self.attacker.enemy = self.defenser
	self.defenser.enemy = self.attacker
	self.state = "init"
	self.warlogs = {}
	self.s2cdata = {
		[self.attacker.pid] = {},
		[self.defenser.pid] = {},
	}
end

function cwar:adds2c(pid,cmd,args)
	local netdata = {pid = pid,cmd=cmd,args=args,}
	local enemypid = self.attacker.pid
	if enemypid == pid then
		enemypid = self.defenser.pid
	end
	if cmd == "putinhand" then
		table.insert(self.s2cdata[pid],netdata)
		netdata = copy(netdata)
		netdata.args = nil
		table.insert(self.s2cdata[enemypid],netdata)
	else
		table.insert(self.s2cdata[pid],netdata)
		table.insert(self.s2cdata[enemypid],netdata)
	end
end

function cwar:s2csync()
	local attacker_s2cdata = self.s2cdata[self.attacker.pid]
	local defenser_s2cdata = self.s2cdata[self.defenser.pid]
	self.s2cdata = {
		[self.attacker.pid] = {},
		[self.defenser.pid] = {},
	}
	--logger.log("debug","war",format("[warid=%d] s2csync,attacker=%d defenser=%d attacker_s2cdata=%s defenser_s2cdata=%s",self.warid,self.attacker.pid,self.defenser.pid,attacker_s2cdata,defenser_s2cdata))
	if next(attacker_s2cdata) then
		cluster.call(self.attacker.srvname,"forward",self.attacker.pid,"war","sync",{
			cmds = attacker_s2cdata
		})
	end
	if next(defenser_s2cdata) then
		cluster.call(self.defenser.srvname,"forward",self.defenser.pid,"war","sync",{
			cmds = defenser_s2cdata
		})
	end
end

function cwar:getwarobj(pid)
	if self.attacker.pid == pid then
		return self.attacker
	else
		assert(self.defenser.pid == pid,"Invalid pid:" .. tostring(pid))
		return self.defenser
	end
end

function cwar:getowner(id)
	if self.attacker.init_warcardid <= id and id <= self.attacker.warcardid then
		return self.attacker 
	elseif self.defenser.init_warcardid <= id and id <= self.defenser.warcardid then
		return self.defenser
	else
		error("Invalid id:" .. tostring(id))
	end

end

function cwar:startwar()
	local msg = string.format("[warid=%d] startwar %d(srvname=%s) -> %d(srvname=%s)",self.warid,self.attacker.pid,self.attacker.srvname,self.defenser.pid,self.defenser.srvname)
	print(msg)
	logger.log("info","war",msg)
	self.state = "startwar"
	-- 洗牌
	self.attacker:shuffle_cards()
	self.defenser:shuffle_cards()
	self.attacker:init_handcard()
	self.defenser:init_handcard()
end

function cwar:endwar(result1,result2)
	local pid1,pid2 = self.attacker.pid,self.defenser.pid
	local warid = self.warid
	self.state = "endwar"
	self.attacker.enemy = nil
	self.defenser.enemy = nil
	local msg = string.format("[warid=%d] endwar,attacker=%d(result=%d) defenser=%d(result=%d)",warid,pid1,result1,pid2,result2)
	logger.log("info","war",msg)
	print(msg)
	cluster.call("warsrvmgr","war","endwar",pid1,warid,result1)
	cluster.call("warsrvmgr","war","endwar",pid2,warid,result2)

end

function cwar:gettargets(targettype)
	if targetid == self.pid then
		return self
	elseif self.init_warcardid <= targetid and targetid <= self.warcardid then
		return self.id_card[targetid]
	else
		local war = warmgr.getobject(self.warid)
		local opponent
		if self.type == "attacker" then
			opponent = war.defenser
		else
			oppoent = war.attacker
		end
		if opponent.init_warcardid <= targetid and targetid <= opponent.warcardid then
			return opponent.id_card[targetid]
		else
			assert(opponent.pid == targetid,"Invalid targetid:" .. tostring(targetid))
			return opponent
		end
	end
end

function cwar:addwarlog(warlog)
	table.insert(self.warlogs,warlog)
end

return cwar
