cwarcard = class("cwarcard")

function cwarcard:init(conf)
	self.id = assert(conf.id)
	self.sid = assert(conf.sid)
	self.warid = assert(conf.warid)
	self.pid = assert(conf.pid)
	self.srvname = assert(conf.srvname)
	self.birthday = assert(conf.birthday)
	self.pos = nil
	self.bsilence = nil
	self.inarea = "cardlib"
	self.halo = {}
	self.haloto = {} -- 光环收益对象:{[id]=true}
	self.halofrom = {}
	self.buffs = {}
	self:initproperty()
	self.hp = self.maxhp	
	self.leftatkcnt = self.atkcnt
end

function cwarcard:initproperty()
	local cardcls = getclassbycardsid(self.sid)
	self.type =  cardcls.type
	self.targettype = cardcls.targettype
	self.choice = cardcls.choice
	self.maxhp = cardcls.hp
	self.atk = cardcls.atk
	self.magic_hurt = cardcls.magic_hurt
	self.recoverhp = cardcls.recoverhp
	self.crystalcost = cardcls.crystalcost
	self.magic_hurt_adden = cardcls.magic_hurt_adden
	self.atkcnt = cardcls.atkcnt
	self.baseattr = {
		maxhp = self.maxhp,
		atk = self.atk,
		crystalcost = self.crystalcost,
	}
end

function cwarcard:initstate()
	local cardcls = getclassbycardsid(self.sid)
	for k,_ in pairs(VALID_STATE) do
		state = cardcls[k] or 0
		self[k] = state
	end
end

function cwarcard:clearallstate()
	for k,_ in pairs(VALID_STATE) do
		self[k] = 0
	end
end

function cwarcard:log(loglevel,filename,...)
	local msg = table.concat({...},"\t")
	msg = string.format("[warid=%d pid=%d srvname=%s] %s",self.warid,self.pid,self.srvname,msg)
	logger.log(loglevel,filename,msg)
end

function cwarcard:canattack()
	if self.cannotattack then -- 无法攻击标志
		return false
	end
	if self:hasstate("freeze") then
		return false
	end
	if self.leftatkcnt <= 0 then
		return false
	end
	if self.atk <= 0 then
		return false
	end
	return true
end

function cwarcard:addleftatkcnt(addval)
	local leftatkcnt = self.leftatkcnt + addval
	leftatkcnt = math.min(self.atkcnt,math.max(0,leftatkcnt))
	self:set({leftatkcnt=leftatkcnt})
end

function cwarcard:addhp(value,srcid)
	if value < 0 then
		return self:costhp(-value,srcid)
	elseif value > 0 then
		return self:recoverhp(value,srcid)
	else
		return 0
	end
end

function cwarcard:costhp(value,srcid)
	assert(value > 0)
	self.hp = math.max(0,self.hp - value)
	self:onhurt(value,srcid)
	if self.hp <= 0 then
		self:die()
	end
	return value
end

function cwarcard:recoverhp(value,srcid)
	assert(value > 0)
	local recoverhp = math.min(value,self.maxhp-self.hp)
	if recoverhp > 0 then
		self:onrecoverhp(recoverhp,srcid)
		self.hp = self.hp + recoverhp
	end
	return recoverhp
end

function cwarcard:getowner(id)
	id = id or self.id
	local war = warmgr.getwar(self.id)
	return war:getowner(id)
end

function cwarcard:get(halos_or_buffs,attr,startpos)
	startpos = startpos or 1
	for pos=#halos_or_buffs,startpos,-1 do
		local v = halos_or_buffs[pos]
		if v[attr] then
			return v[attr],pos
		end
	end
end

-- 得到“增加的值”，如：addatk
function cwarcard:get2(halos_or_buffs,attr,startpos)
	startpos = startpos or 1
	local sumval = 0
	for pos=#halos_or_buffs,startpos,-1 do
		local v = halos_or_buffs[pos]
		if v[attr] then
			sumval = sumval + v[attr]
		end
	end
	return sumval
end

function cwarcard:recompute(attr,ignore_add)
	if ignore_add then
		local halo_val = self:get(self.halofrom,attr)
		if halo_val then
			return halo_val
		end
		local buff_val = self:get(self.buffs,attr)
		if buff_val then
			return buff_val
		end
		return self.baseattr[attr]
	else
		local addattr = "add" .. attr
		local halo_val,pos = self:get(self.halofrom,attr)
		if halo_val then
			local halo_addval = self:get2(self.halofrom,addattr,pos)
			return halo_val + halo_addval
		else
			local buff_val,pos = self:get(self.buffs,attr)
			if buff_val then
				local buff_addval = self:get(self.buffs,addattr,pos)
				local halo_addval = self:get(self.halofrom,addattr)
				return buff_val + buff_addval + halo_addval
			else
				local buff_addval = self:get(self.buffs,addattr)
				local halo_addval = self:get(self.halofrom,addattr)
				return self.baseattr[attr] + buff_addval + halo_addval
			end
		end
	end
end

function cwarcard:set(attrs)
	local updateattrs = {}
	for k,v in pairs(attrs) do
		if self[k] ~= v then
			self[k] = v
			updateattrs[k] = v
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"sync",updateattrs)
end

local NON_COMPUTE_ATTR ={
	id = true,
	sid = true,
	srcid = true,
	exceedround = true,
	addhp = true,
}

function cwarcard:cancompute(attr)
	return not NON_COMPUTE_ATTR[attr]
end

function cwarcard:addbuff(buff)
	buff.exceedround = buff.exceedround or MAX_ROUND
	self:log("info","war",format("addbuff,buff=%s",buff))
	table.insert(self.buffs,buff)
	local syncattrs = {}
	for k,v in pairs(buff) do
		if not self:cancompute(k) then
		elseif self:isstate(k) then
			buff[k] = buff.exceedround
			if buff[k] > self[k] then
				syncattr[k] = buff[k]
			end
		elseif k:sub(1,3) == "add" then
			local attr = k:sub(3)
			syncattrs[attr] = self:recompute(attr)
		else
			syncattrs[attr] = self:recompute(attr)
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"addbuff",buff)
	if buff.addhp then
		syncattrs.hp = math.min(self.hp+buff.addhp,syncattrs.maxhp)
	end
	if next(syncattrs) then
		self:set(syncattrs)
	end
end

function cwarcard:delbuff(pos)
	local buff = table.remove(self.buffs,pos)
	if buff then
		self:log("info","war",format("delbuff,pos=%s buff=%s",pos,buff))
		local syncattrs = {}
		if not self:cancompute(k) then
		elseif self:isstate(k) then
		elseif k:sub(1,3) == "add" then
			local attr = k:sub(3)
			syncattrs[attr] = self:recompute(attr)
		else
			syncattrs[attr] = self:recompute(attr)
		end
		warmgr.refreshwar(self.warid,self.pid,"delbuff",{pos=pos,})
		if syncattrs.maxhp then
			syncattrs.hp = math.min(self.hp,syncattrs.maxhp)
		end
		if next(syncattrs) then
			self:set(syncattrs)
		end
	end
end

function cwarcard:delbuffbysrcid(srcid)
	local delbuffs = {}
	for pos=#self.buffs,1,-1 do
		local buff = self.buffs[pos]
		if buff.srcid == srcid then
			table.insert(delbuffs,pos)
		end
	end
	for i,pos in ipairs(self.delbuffs) do
		self:delbuff(pos)
	end
end

function cwarcard:addhalo(halo)
	halo.exceedround = halo.exceedround or MAX_ROUND
	self:log("info","war",format("addhalo,halo=%s",halo))
	table.insert(self.halofrom,halo)
	local syncattrs = {}
	for k,v in pairs(halo) do
		if not self:cancompute(k) then
		elseif self:isstate(k) then
			-- 光环生成的状态无法被受益者消耗
		elseif k:sub(1,3) == "add" then
			local attr = k:sub(3)
			syncattrs[attr] = self:recompute(attr)
		else
			syncattrs[attr] = self:recompute(attr)
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"addhalo",halo)
	if halo.addhp then
		syncattrs.hp = math.min(self.hp+halo.addhp,syncattrs.maxhp)
	end
	if next(syncattrs) then
		self:set(syncattrs)
	end
end

function cwarcard:delhalo(pos)
	local halo = table.remove(self.halofrom,pos)
	if halo then
		self:log("info","war",format("delhalo,pos=%s halo=%s",pos,halo))
		local syncattrs = {}
		if not self:cancompute(k) then
		elseif self:isstate(k) then
		elseif k:sub(1,3) == "add" then
			local attr = k:sub(3)
			syncattrs[attr] = self:recompute(attr)
		else
			syncattrs[attr] = self:recompute(attr)
		end
		warmgr.refreshwar(self.warid,self.pid,"delhalo",{pos=pos})
		if syncattrs.maxhp then
			syncattrs.hp = math.min(self.hp,syncattrs.maxhp)
		end
		if next(syncattrs) then
			self:set(syncattrs)
		end
	end
end

function cwarcard:delhalobysrcid(srcid)
	local delhalos = {}
	for pos=#self.halofrom,1,-1 do
		local halo = self.halofrom[pos]
		if halo.srcid == srcid then
			table.insert(delhalos,pos)
		end
	end
	for i,pos in ipairs(self.delhalos) do
		self:delhalo(pos)
	end
end

function cwarcard:checkbuffs()
	local owner = self:getowner()
	local delbuffs = {}
	for pos,buff in ipairs(self.buffs) do
		if buff.exceedround and buff.exceedround >= owner.roundcnt then
			table.insert(delbuffs,pos)
		end
	end
	for i=#delbuffs,1,-1 do
		local pos = delbuffs[i]	
		self:delbuff(pos)
	end
end

function cwarcard:checkhalo()
	local owner = self:getowner()
	if self.halo.exceedround and self.halo.exceedround >= owner.roundcnt then
		local haloto = self.haloto
		self.halo = {}
		self.haloto = {}
		local owner = self:getowner()
		for id,_ in pairs(haloto) do
			local warcard = owner:gettarget(id)
			if not warcard:isdie() then
				warcard:delhalobysrcid(self.id)
			end
		end
	end
end

function cwarcard:checkstate()
	local updateattrs = {}
	for k,_ in pairs(VALID_STATE) do
		local exceedround = self[k]
		if exceedround >= self.roundcnt then
			self[k] = 0
			updateattrs[k] = self[k]
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"sync",updateattrs)
end

function cwarcard:getstate(state)
	if self.state > 0 then
		return self.state
	end
	return self:get(self.halofrom,state)
end

function cwarcard:hasstate(state)
	return self:getstate(state) > 0
end

function cwarcard:setstate(state,val)
	if val == 0 or val > self[state] then
		self:set({state=val})
	end
end

function cwarcard:get_magic_hurt()
	local owner = self:getowner()
	-- 只有自身战场随从会影响加成
	local magic_hurt_adden = 0	
	for i,id in ipairs(owner.warcards) do
		local warcard = owner.id_card[id]
		magic_hurt_adden = magic_hurt_adden + warcard.magic_hurt_adden
	end
	-- 只有自身战场随从会影响法伤倍率
	local magic_hurt_multi = 1
	for i,id in ipairs(owner.warcards) do
		local warcard = owner.id_card[id]
		magic_hurt_multi = magic_hurt_multi * warcard.magic_hurt_multi
	end
	return (self.magic_hurt + magic_hurt_adden) * magic_hurt_multi
end

function cwarcard:getrecoverhp()
	-- 只有自身战场随从会影响倍率
	local owner = self:getowner()
	local recoverhp_multi = 1
	for i,id in ipairs(owner.warcards) do
		local warcard = owner.id_card[id]
		recoverhp_multi = recoverhp_multi * warcard.recoverhp_multi
	end
	return self.recoverhp * recoverhp_multi
end

function cwarcard:issilence()
	return self.bsilence
end

function cwarcard:silence()
	logger.log("debug","war",string.format("[warid=%d] #%d card.silence,cardid=%d",self.warid,self.pid,self.id))
	self.bsilence = true
	self.buffs = {}
	self.halo = {}
	self.haloto = {}
	-- 恢复成初始属性
	self:initproperty()
	-- 去掉状态属性
	self:clearallstate()
	self.atkcnt = 1
	self.leftatckcnt = math.min(self.leftatkcnt,self.atkcnt)
	self.magic_hurt_adden = 0
	self.cure_to_hurt = 0
	self.recoverhp_multi = 1
	self.magic_hurt_multi = 1
	self.hp = math.min(self.hp,self.maxhp)
	-- 特殊标记
	if self.cannotattack then
		self.cannotattack = nil
	end

	warmgr.refreshwar(self.warid,self.pid,"synccard",{warcard=self:pack(),})
end

function cwarcard:pack()
	local data = {
		id = self.id,
		sid = self.sid,
		warid = self.warid,
		pid = self.pid,
		birthday = self.birthday,
		pos = self.pos,
		inarea = self.inarea,
		halo = self.halo,
		haloto = table.keys(self.haloto),
		halofrom = self.halofrom,
		buffs = self.buffs,
		atkcnt = self.atkcnt,
		leftatkcnt = self.leftatkcnt,
		type = self.type,
		targettype = self.targettype,
		maxhp = self.maxhp,
		hp = self.hp,
		atk = self.atk,
		crystalcost = self.crystalcost,
		magic_hurt = self.magic_hurt,
		recoverhp = self.recoverhp,
		magic_hurt_adden = self.magic_hurt_adden,
		cannotattack = self.cannotattack,
	}
	for k,_ in pairs(VALID_STATE) do
		data[k] = self[k]
	end
	return data
end

function cwarcard:clone()
	local owner = self:getowner()
	local warcard = owner:newwarcard(self.sid)
	local cloneattr = deepcopy(self)
	for k,v in pairs(cloneattr) do
		if k ~= "id" then
			warcard[k] = v
		end
	end
	return warcard
end


function cwarcard:die()
	if self.inarea == "war" then
		self:getowner():removefromwar(self)
	end
	self.inarea = "graveyard"
	self:ondie()
end

-- 随从牌(战吼)/法术牌(使用效果） 
function cwarcard:onuse(target)
	local cardcls = getclassbycardsid(self.sid)
	if cardcls.onuse then
		cardcls.onuse(self,target)
	end
end

function cwarcard:onputinwar()
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onputinwar then
			cardcls.onputinwar(self)
		end
	end
end

function cwarcard:onremovefromwar()
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onremovefromwar then
			cardcls.onremovefromwar(self)
		end
	end
end

function cwarcard:onputinhand()
	local cardcls = getclassbycardsid(self.sid)
	if cardcls.onputinhand then
		cardcls.onputinhand(self)
	end
end

function cwarcard:onremovefromhand()
	local cardcls = getclassbycardsid(self.sid)
	if cardcls.onremovefromhand then
		cardcls.onremovefromhand(self)
	end
end

function cwarcard:onbeginround(roundcnt)
	self:set({leftatkcnt=self.atkcnt})
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onbeginround then
			cardcls.onbeginround(self,roundcnt)
		end
	end
end


function cwarcard:onendround(hero)
	self:checkhalo()
	self:checkbuffs()
	self:checkstate()
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onendround then
			cardcls.onendround(self,roundcnt)
		end
	end
end

function cwarcard:onattack(target)
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onattack then
			cardcls.onattack(self,target)
		end
	end
end

function cwarcard:ondefense(attacker)
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.ondefense then
			cardcls.ondefense(self,attacker)
		end
	end
end

function cwarcard:onhurt(hurtvalue,srcid)
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onhurt then
			cardcls.onhurt(self,hurtvalue,srcid)
		end
	end
end

function cwarcard:onrecoverhp(hurtvalue,srcid)
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onrecoverhp then
			cardcls.onrecoverhp(self,hurtvalue,srcid)
		end
	end
end

function cwarcard:ondie()
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.ondie then
			cardcls.ondie(self)
		end
	end
end
