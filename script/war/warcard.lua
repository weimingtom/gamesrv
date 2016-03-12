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
	self.inarea = "init"
	self.halo = {}
	self.haloto = {} -- 光环收益对象:{[id]=true}
	self.halofrom = {}
	self.buffs = {}
	self.baseattr = {} -- 原始属性
	self:reinit()
	self.hp = self.maxhp	
	self.leftatkcnt = self.atkcnt
	self:initstate()
	self.effects = {} -- 注册的效果
	self.bheid = 0  -- buff/halo/effects id
end

function cwarcard:reinit()
	local cardcls = getclassbycardsid(self.sid)
	self.type =  cardcls.type
	self.targettype = cardcls.targettype
	self.choice = cardcls.choice
	self.maxhp = cardcls.maxhp
	self.atk = cardcls.atk
	self.crystalcost = cardcls.crystalcost
	self.magic_hurt_adden = cardcls.magic_hurt_adden
	self.cure_to_hurt = cardcls.cure_to_hurt
	self.recoverhp_multi = 1
	self.magic_hurt_multi = 1
	self.atkcnt = cardcls.atkcnt
	self.baseattr.maxhp = self.maxhp
	self.baseattr.atk = self.atk
	self.baseattr.crystalcost = self.crystalcost
	self.atkcnt = self.atkcnt
end

function cwarcard:initstate()
	local cardcls = getclassbycardsid(self.sid)
	for k,_ in pairs(VALID_STATE) do
		local state = cardcls[k] or 0
		self.baseattr[k] = state
		self[k] = state
	end
end

function cwarcard:clearstate()
	for k,_ in pairs(VALID_STATE) do
		self[k] = 0
		self.baseattr[k] = 0
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
	if value == 0 then
		return 0
	end
	if self:hasstate("immune") then
		return
	end
	if self:hasstate("shield") then
		self:setstate("shield",0)
		return
	end
	local ret
	if value < 0 then
		ret = self:__costhp(-value,srcid)
	else
		ret = self:__recoverhp(value,srcid)
	end
	self:set({hp=self.hp})
	return ret
end

function cwarcard:__costhp(value,srcid)
	assert(value > 0)
	local owner = self:getowner()
	if not owner:execute("before_hurt",self,value,srcid) then
		return 0
	end
	self.hp = math.max(0,self.hp - value)
	self:execute("onhurt",value,srcid)
	if self.hp <= 0 then
		self:die()
	end
	owner:execute("after_hurt",self,value,srcid)
	return value
end

function cwarcard:__recoverhp(value,srcid)
	assert(value > 0)
	local recoverhp = math.min(value,self.maxhp-self.hp)
	if recoverhp > 0 then
		local owner =  self:getowner()
		if not owner:execute("before_recoverhp",self,recoverhp,srcid) then
			return 0
		end
		self:execute("onrecoverhp",recoverhp,srcid)
		self.hp = self.hp + recoverhp
		owner:execute("after_recoverhp",self,recoverhp,srcid)
	end
	return recoverhp
end

function cwarcard:getowner(id)
	id = id or self.id
	local war = warmgr.getwar(self.warid)
	return war:getowner(id)
end

function cwarcard:setowner(owner)
	local self_owner = self:getowner()
	if self_owner.pid == owner.pid then
		return
	end
	local card = self_owner:getcard(self.id)
	if card then
		card.pid = owner.pid
		self_owner:delcard(self.id,"setowner")
		owner:addcard(card)
	end
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

-- 得到“增加的值”，:addatk
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
				local buff_addval = self:get2(self.buffs,addattr,pos)
				local halo_addval = self:get2(self.halofrom,addattr)
				return buff_val + buff_addval + halo_addval
			else
				local buff_addval = self:get2(self.buffs,addattr)
				local halo_addval = self:get2(self.halofrom,addattr)
				return self.baseattr[attr] + buff_addval + halo_addval
			end
		end
	end
end

function cwarcard:set(attrs)
	for k,v in pairs(attrs) do
		if self[k] ~= v then
			self[k] = v
		end
	end
	attrs.id = self.id
	warmgr.refreshwar(self.warid,self.pid,"updatecard",attrs)
	if attrs.hp then
		if not self:hasstate("enrage") then
			if self.hp < self.maxhp then
				self:setstate("enrage",1)
			end
		else
			if self.hp >= self.maxhp then
				self:setstate("enrage",0)
			end
		end
	end
end

local NON_COMPUTE_ATTR ={
	id = true,
	sid = true,
	srcid = true,
	bheid = true,
	lifecircle = true,
	exceedround = true,
	addhp = true,
}

function cwarcard:cancompute(attr)
	return not NON_COMPUTE_ATTR[attr]
end

function cwarcard:genbheid()
	if self.bheid > MAX_NUMBER then
		self.bheid = 0
	end
	self.bheid = self.bheid + 1
	return self.bheid
end

function cwarcard:newbuff(buff)
	buff = deepcopy(buff)
	buff.srcid = self.id
	buff.sid  = self.sid
	return buff
end

function cwarcard:getbuff(buffid)
	for i,buff in ipairs(self.buffs) do
		if buff.bheid == buffid then
			return buff
		end
	end
end

function cwarcard:updatebuff(buffid,updateattr)
	local buff = self:getbuff(buffid)
	if not buff then
		return
	end
	for k,v in pairs(updateattr) do
		buff[k] = v
	end
	local syncattrs = {}
	for k,v in pairs(updateattr) do
		if not self:cancompute(k) then
		elseif self:cancoststate(k) then
			self:setstate(k,v)
		elseif self:isstate(k) then
			self:setstate(k,self:recompute(k,true))
		elseif k:sub(1,3) == "add" then
			local attr = k:sub(4)
			syncattrs[attr] = self:recompute(attr)
		else
			syncattrs[k] = self:recompute(k)
		end
	end
	updateattr.bheid = buffid
	warmgr.refreshwar(self.warid,self.pid,"updatebuff",{
		id = self.id,
		buff = updateattr,
	})
	-- 更新buff，只会改变一些无法消耗的属性，如：atk，crystalcost等
	if next(syncattrs) then
		self:set(syncattrs)
	end
end

function cwarcard:addbuff(buff)
	local bheid = self:genbheid()
	buff.bheid = bheid
	if buff.lifecircle then
		local owner = self:getowner()
		buff.exceedround = owner.roundcnt + buff.lifecircle
		buff.lifecircle = nil
	end
	self:log("info","war",format("addbuff,buff=%s",buff))
	table.insert(self.buffs,buff)
	local syncattrs = {}
	for k,v in pairs(buff) do
		if not self:cancompute(k) then
		elseif self:cancoststate(k) then
			self:setstate(k,v)
		elseif self:isstate(k) then
			self:setstate(k,self:recompute(k,true))
		elseif k:sub(1,3) == "add" then
			local attr = k:sub(4)
			syncattrs[attr] = self:recompute(attr)
		else
			syncattrs[k] = self:recompute(k)
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"addbuff",{
		id = self.id,
		buff = buff,
	})
	if buff.addhp then
		syncattrs.hp = math.min(self.hp+buff.addhp,syncattrs.maxhp)
	end
	if next(syncattrs) then
		self:set(syncattrs)
	end
end

function cwarcard:delbuffbypos(pos)
	local buff = table.remove(self.buffs,pos)
	if buff then
		self:log("info","war",format("delbuff,pos=%s buff=%s",pos,buff))
		local syncattrs = {}
		for k,v in pairs(buff) do
			if not self:cancompute(k) then
			elseif self:cancoststate(k) then
			elseif self:isstate(k) then
				self:setstate(k,self:recompute(k,true))
			elseif k:sub(1,3) == "add" then
				local attr = k:sub(4)
				syncattrs[attr] = self:recompute(attr)
			else 
				syncattrs[k] = self:recompute(k)
			end
		end
		warmgr.refreshwar(self.warid,self.pid,"delbuff",{
			id = id,
			pos = pos,
		})
		if syncattrs.maxhp then
			syncattrs.hp = math.min(self.hp,syncattrs.maxhp)
		end
		if next(syncattrs) then
			self:set(syncattrs)
		end
	end
end

function cwarcard:delbuff(id)
	for pos=#self.buffs,1,-1 do
		local buff = self.buffs[pos]
		if buff.id == id then
			self:delbuffbypos(pos)
			return buff
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
		self:delbuffbypos(pos)
	end
end

function cwarcard:addhaloto(warcard)
	local cardcls = getclassbycardsid(self.sid)
	if not cardcls.halo then
		return
	end
	local halo = deepcopy(cardcls.halo)
	halo.srcid = self.id
	halo.sid = self.sid
	self.haloto[warcard.id] = true
	warcard:addhalo(halo)
end

function cwarcard:addhalo(halo)
	local bheid = self:genbheid()
	halo.bheid = bheid
	if halo.lifecircle then
		local owner = self:getowner()
		halo.exceedround = owner.roundcnt + halo.lifecircle
		halo.lifecircle = nil
	end
	self:log("info","war",format("addhalo,halo=%s",halo))
	table.insert(self.halofrom,halo)
	local syncattrs = {}
	for k,v in pairs(halo) do
		if not self:cancompute(k) then
		elseif self:cancoststate(k) then
			-- 光环不能生成"可消耗属性"
			error("invalid halo attrubitue:" .. k)
		elseif self:isstate(k) then
			self:setstate(k,self:recompute(k,true))
		elseif k:sub(1,3) == "add" then
			local attr = k:sub(4)
			syncattrs[attr] = self:recompute(attr)
		else
			syncattrs[k] = self:recompute(k)
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"addhalo",{
		id = self.id,
		halo = halo,
	})
	if halo.addhp then
		syncattrs.hp = math.min(self.hp+halo.addhp,syncattrs.maxhp)
	end
	if next(syncattrs) then
		self:set(syncattrs)
	end
end

function cwarcard:delhalobypos(pos)
	local halo = table.remove(self.halofrom,pos)
	if halo then
		local owner = self:getowner()
		local halofrom_warcard = owner:gettarget(halo.srcid)
		halofrom_warcard.haloto[self.id] = nil
		self:log("info","war",format("delhalo,pos=%s halo=%s",pos,halo))
		local syncattrs = {}
		for k,v in pairs(halo) do
			if not self:cancompute(k) then
			elseif self:cancoststate(k) then
				-- 光环不能生成"可消耗属性"
				error("invalid halo attrubitue:" .. k)
			elseif self:isstate(k) then
				self:setstate(k,self:recompute(k,true))
			elseif k:sub(1,3) == "add" then
				local attr = k:sub(4)
				syncattrs[attr] = self:recompute(attr)
			else
				syncattrs[k] = self:recompute(k)
			end
		end
		warmgr.refreshwar(self.warid,self.pid,"delhalo",{
			id = self.id,
			pos = pos,
		})
		if syncattrs.maxhp then
			syncattrs.hp = math.min(self.hp,syncattrs.maxhp)
		end
		if next(syncattrs) then
			self:set(syncattrs)
		end
	end
end

function cwarcard:delhalobysrcid(srcid)
	-- 一个卡牌对其他卡牌光环效果最多只有一个，即#delhalos<=1
	local delhalos = {}
	for pos=#self.halofrom,1,-1 do
		local halo = self.halofrom[pos]
		if halo.srcid == srcid then
			table.insert(delhalos,pos)
		end
	end
	for i,pos in ipairs(delhalos) do
		self:delhalobypos(pos)
	end
end

function cwarcard:checkbuff()
	local owner = self:getowner()
	local delbuffs = {}
	for pos,buff in ipairs(self.buffs) do
		if buff.exceedround and buff.exceedround >= owner.roundcnt then
			table.insert(delbuffs,pos)
		end
	end
	for i=#delbuffs,1,-1 do
		local pos = delbuffs[i]	
		self:delbuffbypos(pos)
	end
end

function cwarcard:checkhalo()
	local owner = self:getowner()
	if self.halo.exceedround and self.halo.exceedround >= owner.roundcnt then
		local haloto = self.haloto
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
	local owner = self:getowner()
	local updateattrs = {}
	for k,_ in pairs(CAN_COST_STATE) do
		local exceedround = self[k]
		if exceedround then
			if exceedround ~= 0 and exceedround <= owner.roundcnt then
				self[k] = 0
				updateattrs[k] = self[k]
			end
		end
	end
	if next(updateattrs) then
		updateattrs.id = self.id
		warmgr.refreshwar(self.warid,self.pid,"updatecard",updateattrs)
	end
end

function cwarcard:clearbuff()
	self.buffs = {}
end

function cwarcard:clearhalo()
	self:clearhaloto()
	self:clearhalofrom()
end

function cwarcard:clearhaloto()
	if next(self.haloto) then
		local owner = self:getowner()
		local haloto = self.haloto
		self.haloto = {}
		for id,_ in pairs(haloto) do
			local target = owner:gettarget(id)
			target:delhalobysrcid(self.id)
		end
	end
end

function cwarcard:clearhalofrom()
	local owner = self:getowner()
	local halofrom = self.halofrom
	self.halofrom = {}
	for i,halo in ipairs(halofrom) do
		local warcard = owner:gettarget(halo.srcid)
		warcard.haloto[self.id] = nil
	end
	warmgr.refreshwar(self.warid,self.pid,"clearhalofrom",{
		id = self.id,
	})
end

function cwarcard:clear()
	self:clearstate()
	self:clearbuff()
	self:clearhalo()
	self:cleareffect()
	self.bsilence = nil
	self.cannotattack = nil
end

function cwarcard:packeffect(effect)
	local tbl = {}
	for k,v in pairs(effect) do
		if type(v) ~= "function" then
			tbl[k] = v
		end
	end
	return tbl
end

function cwarcard:neweffect(effect)
	effect = deepcopy(effect)
	effect.srcid = self.id
	effect.sid = self.sid
	return effect
end

function cwarcard:addeffect(effect)
	local name = assert(effect.name)
	if not effect.bheid then
		local bheid = self:genbheid()
		effect.bheid = self.bheid
	end
	local packeffect = self:packeffect(effect)
	self:log("info","war",format("addeffect,effect=%s",packeffect))
	if not self.effects[name] then
		self.effects[name] = {}
	end
	table.insert(self.effects[name],effect)
	warmgr.refreshwar(self.warid,self.pid,"addeffect",{
		id = self.id,
		effect = packeffect,
	})
	return effect.bheid
end

function cwarcard:cloneeffect(id,name)
	local owner = self:getowner()
	local target = owner:gettarget(id)
	if not target:issilence() then
		local cardcls = getclassbycardsid(target.sid)
		if cardcls[name] then
			local effect = {
				name = name,
				srcid = id,
				sid = target.sid,
				func = cardcls[name],
			}
			self:addeffect(effect)
		end
	end
	if target.effects[name] then
		for i,effect in ipairs(target.effects[name]) do
			self:addeffect(effect)
		end
	end
end

function cwarcard:cleareffect(name)
	if name then
		if self.effects[name] then
			self.effects[name] = {}
		end
	else
		self.effects = {}
	end
end

function cwarcard:deleffectbyid(bheid,name)
	if name then
		return self:__deleffectbysrcid(bheid,self.effects[name])
	else
		for i,effects in ipairs(self.effects) do
			local effect = self__deleffectbyid(bheid,effects)
			if effect then
				return effect
			end
		end
	end
end

function cwarcard:__deleffectbyid(bheid,effects)
	for pos=#effects,1,-1 do
		local effect = effects[pos]
		if effect.bheid == bheid then
			return table.remove(effects,pos)
		end
	end
end

function cwarcard:deleffectbysrcid(srcid,name)
	if name then
		self:__deleffectbysrcid(srcid,self.effects[name])
	else
		for name,effects in ipairs(self.effects) do
			self:__deleffectbysrcid(srcid,effects)
		end
	end
end

function cwarcard:__deleffectbysrcid(srcid,effects)
	for pos=#effects,1,-1 do
		local effect = effects[pos]
		if effect.srcid == srcid then
			table.remove(effects,pos)
		end
	end
end

function cwarcard:cancoststate(attr)
	return CAN_COST_ATTR[attr]
end

function cwarcard:isstate(state)
	return VALID_STATE[state]
end

function cwarcard:getstate(name)
	local state = self[name] or 0
	if state > 0 then
		return self.state
	end
	return self:get(self.halofrom,name)
end

function cwarcard:hasstate(name)
	local state = self:getstate()
	if state then
		return state > 0
	end
	return false
end

function cwarcard:setstate(name,newval)
	local owner = self:getowner()
	newval = newval == 0 and newval or newval + owner.roundcnt
	local oldval = self[name] or 0
	if newval == oldval then
		return
	end
	if oldval ~= newval then
		self:set({[name]=newval})
	end
	if oldval == 0 and newval ~= 0 then
		self:execute("onchangestate",name,oldval,newval)
	elseif oldval ~= 0 and newval == 0 then
		self:execute("onchangestate",name,oldval,newval)
	end
end

function cwarcard:get_magic_hurt(magic_hurt)
	local owner = self:getowner()
	return owner:get_magic_hurt(magic_hurt)
end

function cwarcard:getrecoverhp(recoverhp)
	-- 只有自身战场随从会影响倍率
	local owner = self:getowner()
	return owner:getrecoverhp(recoverhp)
end


function cwarcard:getatk()
	return self.atk
end

-- 得到复仇值(eye for eye):被攻击时对对方造成的伤害
function cwarcard:gete4e()
	return self:getatk()
end

function cwarcard:getsidbychoice(choice)
	local key = string.format("choice%d",choice)
	local cardcls = getclassbycardsid(self.sid)
	return cardcls.effect.onuse[key]
end

function cwarcard:issilence()
	return self.bsilence
end

function cwarcard:silence()
	logger.log("debug","war",string.format("[warid=%d] #%d card.silence,cardid=%d",self.warid,self.pid,self.id))
	-- 恢复成初始属性
	self:reinit()
	self:clear()
	self.bsilence = true
	self.atkcnt = 1
	self.leftatckcnt = math.min(self.leftatkcnt,self.atkcnt)
	self.magic_hurt_adden = 0
	self.cure_to_hurt = 0
	self.recoverhp_multi = 1
	self.magic_hurt_multi = 1
	self.hp = math.min(self.hp,self.maxhp)
	warmgr.refreshwar(self.warid,self.pid,"synccard",{card=self:pack(),})
end

function cwarcard:pack()
	local effects = {}
	for name,list in ipairs(self.effects) do
		for i,effect in ipairs(list) do
			table.insert(effects,self:packeffect(effect))
		end
	end
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
		effects = effects,
		atkcnt = self.atkcnt,
		leftatkcnt = self.leftatkcnt,
		type = self.type,
		targettype = self.targettype,
		maxhp = self.maxhp,
		hp = self.hp,
		atk = self.atk,
		crystalcost = self.crystalcost,
		magic_hurt_adden = self.magic_hurt_adden,
		cannotattack = self.cannotattack,
	}
	for k,_ in pairs(VALID_STATE) do
		data[k] = self[k]
	end
	return data
end

function cwarcard:isdie()
	return self.inarea == "graveyard"
end

function cwarcard:die()
	assert(self.inarea=="war")
	local owner = self:getowner()
	if not owner:execute("before_die",self) then
		return
	end
	self:execute("ondie")
	owner:execute("after_die",self)
	if is_footman(self.type) then
		owner:removefromwar(self)
	elseif is_weapon(self.type) then
		owner:delweapon()
	else
	end
end

function cwarcard:canplaycard(pos,targetid,choice)
	local cardcls = getclassbycardsid(self.sid)
	if cardcls.canplaycard then
		return cardcls.canplaycard(self,pos,targetid,choice)
	end
	return true
end

function cwarcard:onbeginround()
	self:set({leftatkcnt=self.atkcnt})
	self:checkbuff()
	self:checkhalo()
	self:checkstate()
end


function cwarcard:onendround(hero)
	self:checkbuff()
	self:checkhalo()
	self:checkstate()
end

function cwarcard:onchangestate(name,oldval,newval)
	local owner = self:getowner()
	if name == "assault" then
		if oldval == 0 and newval ~= 0 then
			if self.inarea == "war" then
				-- 刚入场随从，获得冲锋状态后，本回合可以攻击
				if self.enterwar_roundcnt == owner.roundcnt then
					self:set({
						leftatkcnt = self.atkcnt,
					})
				end
			end
		end
	end
end

function cwarcard:onputinwar()
	local leftatkcnt
	-- 刚入场随从，非“冲锋”状态下无法立即攻击
	if self:hasstate("assault") then
		leftatkcnt = self.atkcnt
	else
		leftatkcnt = 0
	end
	self:set({
		leftatkcnt = leftatkcnt,
		hp = self.maxhp,
	})
end

function cwarcard:onremovefromwar()
	self:clearhalo()
end

function cwarcard:onputinhand()
	self:reinit()
	self:clear()
end


function cwarcard:execute(cmd,...)
	local noexec_later_action = false
	local func = self[cmd]
	if func then
		local ignore_later_event,ignore_later_action = func(self,...)
		if ignore_later_action then
			noexec_later_action = true
		end
		if ignore_later_event then
			return true,noexec_later_action
		end
	end
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		local func = cardcls[cmd]
		if func then
			local ignore_later_event,ignore_later_action = func(self,...)
			if ignore_later_action then
				noexec_later_action = true
			end
			if ignore_later_event then
				return true,noexec_later_action
			end
		end
	end
	if self.effects[cmd] then
		for i,effect in ipairs(self.effects[cmd]) do
			local func = effect.callback
			local ignore_later_event,ignore_later_action = func(self,...)
			if ignore_later_action then
				noexec_later_action = true
			end
			if ignore_later_event then
				return true,noexec_later_action
			end
		end
	end
	return false,noexec_later_action
end

return cwarcard
