
require "script.war.warobj"
require "script.war.aux"

--- 1. player ready
--- 2. startwar
--- 3. loopround
--- 4. endwar

__warid = __warid or 0

function genwarid()
	if __warid >= MAX_NUMBER then
		__warid = 0
	end
	__warid = __warid + 1
	return __warid
end

cwar = class("cwar",cdatabaseable)

function cwar:init(profile1,profile2)
	cdatabaseable.init(self,{
		pid = 0,
		flag = "cwar",
	})
	self.data = {}
	self.warid = genwarid()
	self.cardid = CARD_MIN_ID
	self.inorder = 0 -- 随从置入战场顺序
	self.attacker = cwarobj.new(profile1,self.warid)
	self.defenser = cwarobj.new(profile2,self.warid)
	self.attacker.enemy = self.defenser
	self.defenser.enemy = self.attacker
	self.state = "init"
	self.s2cdata = {
		attacker = {}, -- 进攻方可见数据
		defenser = {}, -- 防守方可见数据
		attacker_sendpos = 1,
		defenser_sendpos = 1,
		attacker_listener = {},
		defenser_listener = {},
	}
end

function cwar:gen_inorder()
	self.inorder = self.inorder + 1
	return self.inorder
end

function cwar:gencardid()
	if self.cardid >= CARD_MAX_ID then
		self:endwar(WARRESULT_TIE)
		return
	end
	self.cardid = self.cardid + 1
	return self.cardid
end

function cwar:adds2c(pid,cmd,args)
	local netdata = {pid = pid,cmd=cmd,args=args,}
	local self_s2cdata,enemy_s2cdata
	if pid == self.attacker.pid then
		self_s2cdata = self.s2cdata.attacker
		enemy_s2cdata = self.s2cdata.defenser
	else
		assert(pid == self.defenser.pid)
		self_s2cdata = self.s2cdata.defenser
		enemy_s2cdata = self.s2cdata.attacker
	end
	if cmd == "putinhand" then
		table.insert(self_s2cdata,netdata)
		netdata = copy(netdata)
		netdata.args = nil
		table.insert(enemy_s2cdata,netdata)
	else
		table.insert(self_s2cdata,netdata)
		table.insert(enemy_s2cdata,netdata)
	end
end

function cwar:s2csync()
	local attacker_endpos = #self.s2cdata.attacker
	local defenser_endpos = #self.s2cdata.defenser
	local attacker_s2cdata = slice(self.s2cdata.attacker,self.s2cdata.attacker_sendpos,attacker_endpos)
	local defenser_s2cdata = slice(self.s2cdata.defenser,self.s2cdata.defenser_sendpos,defenser_endpos)
	self.s2cdata.attacker_sendpos = attacker_endpos + 1
	self.s2cdata.defenser_sendpos = defenser_endpos + 1
	if next(attacker_s2cdata) then
		cluster.call(self.attacker.srvname,"forward",self.attacker.pid,"war","sync",{
			cmds = attacker_s2cdata,
		})
	end
	if next(defenser_s2cdata) then
		cluster.call(self.defenser.srvname,"forward",self.defenser.pid,"war","sync",{
			cmds = defenser_s2cdata
		})
	end
	-- watcher
	if next(attacker_s2cdata) then
		for i,v in ipairs(self.s2cdata.attacker_listener) do
			cluster.call(v.srvname,"forward",v.pid,"war","sync",{
				cmds = attacker_s2cdata,
			})
		end
	end
	if next(defenser_s2cdata) then
		for i,v in ipairs(self.s2cdata.defenser_listener) do
			cluster.call(v.srvname,"forward",v.pid,"war","sync",{
				cmds = defenser_s2cdata,
			})
		end
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

function cwar:startwar()
	local msg = string.format("[warid=%d] startwar,attacker=%d(name=%s srvname=%s) defenser=%d(name=%s srvname=%s)",self.warid,self.attacker.pid,self.attacker.name,self.attacker.srvname,self.defenser.pid,self.defenser.name,self.defenser.srvname)
	print(msg)
	logger.log("info","war",msg)
	self.state = "startwar"
	-- 洗牌
	self.attacker:shuffle_cards()
	self.defenser:shuffle_cards()
	self.attacker:init_handcard()
	self.defenser:init_handcard()
end

function cwar:endwar(result,stat)
	stat = stat or {}
	local attacker_result,defenser_result
	if result == WARRESULT_WIN then
		attacker_result = WARRESULT_WIN
		defenser_result = WARRESULT_LOSE
	elseif result == WARRESULT_LOSE then
		attacker_result = WARRESULT_LOSE
		defenser_result = WARRESULT_WIN
	else
		assert(result == WARRESULT_TIE)
		attacker_result = WARRESULT_TIE
		defenser_result = WARRESULT_TIE
	end
	local warid = self.warid
	self.state = "endwar"
	self.attacker.enemy = nil
	self.defenser.enemy = nil
	local msg = string.format("[warid=%d] endwar,attacker=%d(name=%s srvname=%s) defenser=%d(name=%s srvname=%s) result=%s",warid,self.attacker.pid,self.attacker.name,self.attacker.srvname,self.defenser.pid,self.defenser.name,self.defenser.srvname,result)
	logger.log("info","war",msg)
	cluster.call("warsrvmgr","war","endwar",self.attacker.pid,warid,attacker_result,stat.attacker)
	cluster.call("warsrvmgr","war","endwar",self.defenser.pid,warid,defenser_result,stat.defenser)
end

return cwar
