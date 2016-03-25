
require "script.war.warobj"
require "script.war.auxilary"

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

function cwar:init(attacker,defenser)
	cdatabaseable.init(self,{
		pid = 0,
		flag = "cwar",
	})
	self.data = {}
	self.source = nil -- 战斗管理服名(createwar后设置)
	self.createtime = os.time()
	self.warid = genwarid()
	self.cardid = CARD_MIN_ID
	self.inorder = 0 -- 随从置入战场顺序
	attacker.isattacker = true
	self.attacker = cwarobj.new(attacker,self.warid)
	self.defenser = cwarobj.new(defenser,self.warid)
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

function cwar:forward(srvname,pid,netdata,startpos,endpos)
	for pos=startpos,endpos,50 do
		local cmds = slice(netdata,pos,pos+50)
		cluster.call(srvname,"forward",pid,"war","sync",{
			cmds = cmds,
		})
	end
end

function cwar:s2csync()
	local attacker_endpos = #self.s2cdata.attacker
	local defenser_endpos = #self.s2cdata.defenser
	local attacker_sendpos = self.s2cdata.attacker_sendpos
	local defenser_sendpos = self.s2cdata.defenser_sendpos
	self.s2cdata.attacker_sendpos = attacker_endpos + 1
	self.s2cdata.defenser_sendpos = defenser_endpos + 1
	if attacker_sendpos < attacker_endpos then
		self:forward(self.attacker.srvname,self.attacker.pid,self.s2cdata.attacker,attacker_sendpos,attacker_endpos)
	end
	if defenser_sendpos < defenser_endpos then
		self:forward(self.defenser.srvname,self.defenser.pid,self.s2cdata.defenser,defenser_sendpos,defenser_endpos)
	end
	-- watcher
	if attacker_sendpos < attacker_endpos then
		for i,v in ipairs(self.s2cdata.attacker_listener) do
			self:forward(v.srvname,v.pid,self.s2cdata.attacker,attacker_sendpos,attacker_endpos)
		end
	end
	if defenser_sendpos < defenser_endpos then
		for i,v in ipairs(self.s2cdata.defenser_listener) do
			self:forward(v.srvname,v.pid,self.s2cdata.defenser,defenser_sendpos,defenser_endpos)
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

function cwar:getowner(id)
	local card = self.attacker:getcard(id)
	if not card then
		card = self.defenser:getcard(id)
	end
	if card.pid == self.attacker.pid then
		return self.attacker
	else
		assert(card.pid == self.defenser.pid)
		return self.defenser
	end
end

function cwar:startwar()
	local msg = string.format("[warid=%d] startwar,attacker=(pid=%s name=%s srvname=%s) defenser=(pid=%s name=%s srvname=%s)",self.warid,self.attacker.pid,self.attacker.name,self.attacker.srvname,self.defenser.pid,self.defenser.name,self.defenser.srvname)
	logger.log("info","war",msg)
	cluster.call(self.source,"war","startwar",{
		pid = self.attacker.pid,
		warid = self.warid,
	})
	cluster.call(self.source,"war","startwar",{
		pid = self.defenser.pid,
		warid = self.warid,
	})
	self.state = "startwar"
	-- 洗牌
	self.attacker:shuffle_cards()
	self.defenser:shuffle_cards()
	self.attacker:ready_handcard()
	self.defenser:ready_handcard()
end

function cwar:endwar(result)
	-- 战斗统计信息
	local stat =  {}
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
	local msg = string.format("[warid=%d] endwar,attacker=(pid=%s name=%s srvname=%s) defenser=(pid=%s name=%s srvname=%s) result=%s",warid,self.attacker.pid,self.attacker.name,self.attacker.srvname,self.defenser.pid,self.defenser.name,self.defenser.srvname,result)
	logger.log("info","war",msg)
	cluster.call(self.source,"war","endwar",{
		pid = self.attacker.pid,
		warid = self.warid,
		result = attacker_result,
		stat = stat.attacker,
	})
	cluster.call(self.source,"war","endwar",{
		pid = self.defenser.pid,
		warid = self.warid,
		result = defenser_result,
		stat = stat.defenser,
	})
end

--/*
--检查战斗是否结束(每个动作执行完后检查战斗是否结束)
--@return boolean :true--战斗可以结束，false--战斗尚未结束
--*/
function cwar:check_endwar()
	if self.attacker.giveupwar then
		self:endwar(WARRESULT_LOSE)
		return true
	end
	if self.defenser.giveupwar then
		self:endwar(WARRESULT_WIN)
		return true
	end
	if self.attacker.hero.hp <= 0 then
		if self.defenser.hero.hp <= 0 then
			self:endwar(WARRESULT_TIE)
			return true
		else
			self:endwar(WARRESULT_LOSE)
			return true
		end
	elseif self.defenser.hero.hp <= 0 then
		self:endwar(WARRESULT_WIN)
		return true
	end
	if self.attacker.roundcnt > MAX_ROUNDCNT then
		self:endwar(WARRESULT_TIE)
		return true
	end
	local now = os.time()
	if now - self.createtime > HOUR_SECS then
		self:endwar(WARRESULT_TIE)
		return true
	end
	return false
end

return cwar
