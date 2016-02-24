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
	self.hurt = 0
	self.leftatkcnt = self.atkcnt
end

function cwarcard:initproperty()
	local cardcls = getclassbycardsid(self.sid)
	self.type =  cardcls.type
	self.targettype = cardcls.targettype
	self.choice = cardcls.choice
	self.maxhp = cardcls.hp
	self.hp = self.maxhp
	self.atk = cardcls.atk
	self.magic_hurt = cardcls.magic_hurt
	self.recoverhp = cardcls.recoverhp
	self.crystalcost = cardcls.crystalcost
	self.magic_hurt_adden = cardcls.magic_hurt_adden
	self.atkcnt = cardcls.atkcnt
	self.magic_immune = cardcls.magic_immune
	self.assault = cardcls.assault
	self.sneer = cardcls.sneer
	self.shield = cardcls.shield
end

function cwarcard:log(loglevel,filename,...)
	local msg = table.concat({...},"\t")
	msg = string.format("[warid=%d pid=%d srvname=%s] %s",self.warid,self.pid,self.srvname,msg)
	logger.log(loglevel,filename,msg)
end

function cwarcard:addleftatkcnt(value)
	local v = math.max(0,self.leftatkcnt + value)
	self:setleftatkcnt(v)
end

function cwarcard:setleftatkcnt(atkcnt,nosync)
	local oldleftatkcnt = self.leftatkcnt
	if oldleftatkcnt ~= atkcnt then
		self.leftatkcnt = atkcnt
		if not nosync then
			warmgr.refreshwar(self.warid,self.pid,"setleftatkcnt",{id=self.id,value=self.leftatkcnt,})
		end
	end
end

function cwarcard:setatkcnt(atkcnt,nosync)
	local oldatkcnt = self.atkcnt
	if oldatkcnt ~= atkcnt then
		self.atkcnt = atkcnt
		if not nosync then
			warmgr.refreshwar(self.warid,self.pid,"setatkcnt",{id=self.id,value=self.atkcnt,})
		end
		self:addleftatkcnt(atkcnt-oldatkcnt)
	end

end

function cwarcard:gethp()
	return self.hp
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
	local oldhp = self:gethp()
	local maxhp,inorder = self:get("maxhp")
	for i=#self.buffs,1,-1 do
		local buff = self.buffs[i]
		if buff.inorder > inorder then
			if buff.addhp and buff.addhp > 0 then
				local costhp = math.min(buff.addhp,value)
				buff.addhp = buff.addhp - costhp
				value = value - costhp
				if value == 0 then
					break
				end
			else
				break
		end
	end
	local hurt = value
	if hurt > 0 then
		self.hurt = self.hurt + hurt
		self.hp = oldhp - hurt
		self:onhurt(hurt,srcid)
		if self.hp <= 0 then
			self:die()
		end
	end
	return hurt
end

function cwarcard:recoverhp(value,srcid)
	assert(value > 0)
	local oldhp = self:gethp()
	local maxhp,inorder = self:get("maxhp")
	self.hp = oldhp + value
	self.hp = math.min(self.hp,maxhp)
	local recoverhp = self.hp - oldhp
	if recoverhp > 0 then
		self:onrecoverhp(recoverhp,srcid)
	end
	return recoverhp
end

function cwarcard:addhp(value,srcid)
	local hp = self:gethp()
	logger.log("debug","war",string.format("[warid=%d] #%d warcard.addhp,id=%d hp=%d+%d srcid=%d",self.warid,self.pid,self.id,hp,value,srcid))
	if self:isdie() then
		return
	end
	local maxhp = self:getmaxhp()
	local oldhp = self:gethp()
	value = math.min(maxhp - hp,value)
	if value > 0 then
		if self:__onaddhp(value) then
			return
		end
		if self.hp < self.maxhp then
			local addval = self.maxhp - self.hp
			value = value - addval
			self.hp = self.hp + addval
		end
		if value > 0 then
			if self.halo.addhp < self.halo.addmaxhp then
				local addval = self.halo.addmaxhp - self.halo.addhp
				value = value - addval
				self.halo.addhp = self.halo.addhp + addval
			end
			if value > 0 then
				if self.buff.addhp < self.buff.addmaxhp then
					local addval = self.buff.addmaxhp - self.buff.addhp
					value = value - addval
					self.buff.addhp = self.buff.addhp + addval
				end
			end
		end
	elseif value < 0 then
		-- 免疫状态回合结束时结
		if self:getstate("immune") then
			return
		end
		if self:getstate("shield") then
			self:delstate("shield")
			return
		end
		value = -value
		if self:__onhurt(value,srcid) then
			return
		end
		if self.buff.addhp > 0 then
			local costhp = math.min(self.buff.addhp,value)
			value = value - costhp
			self.buff.addhp = self.buff.addhp - costhp
		end
		if value > 0 then
			if self.halo.addhp > 0 then
				local costhp = math.min(self.halo.addhp,value)
				value = value - costhp
				self.halo.addhp = self.halo.addhp - costhp
			end
			if value > 0 then
				assert(self.hp > 0)
				self.hp = self.hp - value
				self.hurt = self.hurt + value
			end
		end
	end
	local newhp = self:gethp()
	if oldhp ~= newhp then
		warmgr.refreshwar(self.warid,self.pid,"sethp",{id=self.id,value=newhp,})
	end
	if newhp == maxhp then
		self:delstate("enrage")
	else
		assert(newhp < maxhp,string.format("hp(%d) > maxhp(%d)",newhp,maxhp))
		self:setstate("enrage",1)
	end
	if self.hp <= 0 then
		self:setdie()
	end
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
	if ignore_add then -- 状态熟悉只有设置值，没有增加值
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

function cwarcard:addbuff(buff)
	buff.exceedround = buff.exceedround or MAX_ROUND
	self:log("info","war",format("addbuff,buff=%s",buff))
	table.insert(self.buffs,buff)
	local syncattrs = {}
	for k,v in pairs(buff) do
		if self:isstate(k) then
			syncattrs[k] = self:recompute(k,true)
		elseif k == "addmaxhp" or k == "maxhp" then
			syncattrs.maxhp = self:recompute("maxhp")
			if buff.addhp then -- 增加生命值上限的同时加生命值
				assert(buff.addhp == buff.addmaxhp)
				syncattrs.hp = math.min(self.hp+buff.addhp,syncattrs.maxhp)
			end
		elseif k == "addatk" or k == "atk" then
			syncattrs.atk = self:recompute("atk")
		elseif k == "addcrystalcost" or k == "crystalcost" then
			syncattrs.crystalcost = self:recompute("crystalcost")
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"addbuff",buff)
	if next(syncattrs) then
		self:set(syncattrs)
	end
end

function cwarcard:delbuff(pos)
	local buff = table.remove(self.buffs,pos)
	if buff then
		self:log("info","war",format("delbuff,pos=%s buff=%s",pos,buff))
		local syncattrs = {}
		if self:isstate(k) then
			syncattrs[k] = self:recompute(k,true)
		elseif k:sub(1,3) == "add" then
			local attr = k:sub(3)
			syncattrs[attr] = self:recompute(attr)
		else
			syncattrs[attr] = self:recompute(attr)
		end
		warmgr.refreshwar(self.warid,self.pid,"delbuff",{pos=pos,})
		if next(syncattrs) then
			if syncattrs.addhp then
			end
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
		if self:isstate(k) then
			syncattrs[k] = self:recompute(k,true)
		elseif k == "addmaxhp" or k == "maxhp" then
			syncattrs.maxhp = self:recompute("maxhp")
			if halo.addhp then -- 增加生命值上限的同时加生命值
				assert(halo.addhp == halo.addmaxhp)
				syncattrs.hp = math.min(self.hp+halo.addhp,syncattrs.maxhp)
			end
		elseif k == "addatk" or k == "atk" then
			syncattrs.atk = self:recompute("atk")
		elseif k == "addcrystalcost" or k == "crystalcost" then
			syncattrs.crystalcost = self:recompute("crystalcost")
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"addhalo",halo)
	if next(syncattrs) then
		self:set(syncattrs)
	end
end

function cwarcard:delhalo(pos)
	local halo = table.remove(self.halofrom,pos)
	if halo then
		self:log("info","war",format("delhalo,pos=%s halo=%s",pos,halo))
		local syncattrs = {}
		if self:isstate(k) then
			syncattrs[k] = self:recompute(k,true)
		elseif k == "addmaxhp" or k == "maxhp" then
			syncattrs.maxhp = self:recompute("maxhp")
			syncattrs.hp = math.min(self.hp,syncattrs.maxhp)
		elseif k == "addatk" or k == "atk" then
			syncattrs.atk = self:recompute("atk")
		elseif k == "addcrystalcost" or k == "crystalcost" then
			syncattrs.crystalcost = self:recompute("crystalcost")
		end
		warmgr.refreshwar(self.warid,self.pid,"delhalo",{pos=pos})
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

function cwarcard:getstate(state)
	return self[state]
end

function cwarcard:hasstate(state)
	return self:getstate(state) > 0
end

function cwarcard:gethp()
	return self.hp
end

function cwarcard:getatk()
	return self.atk
end

function cwarcard:gethp()
	return self.hp
end

function cwarcard:getmaxhp()
	return self.maxhp
end

function cwarcard:getcrystalcost()
	return self.crystalcost
end

function cwarcard:get_magic_hurt_adden()
	return self.magic_hurt_adden
end

function cwarcard:get_magic_hurt()
	local owner = self:getowner()
	-- 只有自身战场随从会影响加成
	local magic_hurt_adden = 0	
	for i,id in ipairs(owner.warcards) do
		local warcard = owner.id_card[id]
		magic_hurt_adden = magic_hurt_adden + warcard:get_magic_hurt_adden()
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
	self.magic_immune = 0
	self.assault = 0
	self.sneer = 0
	self.atkcnt = 1
	self.leftatckcnt = math.min(self.leftatkcnt,self.atkcnt)
	self.shield = 0
	self.sneak = 0
	self.magic_hurt_adden = 0
	self.cure_to_hurt = 0
	self.recoverhp_multi = 1
	self.magic_hurt_multi = 1
	-- 伤害继承
	self.hp = self.maxhp - self.hurt
	warmgr.refreshwar(self.warid,self.pid,"synccard",{warcard=self:pack(),})
end

function cwarcard:pack()
	return {
		id = self.id,
		sid = self.sid,
		warid = self.warid,
		pid = self.pid,
		birthday = self.birthday,
		pos = self.pos,
		inarea = self.inarea,
		halo = self.halo,
		haloto = table.keys(self.haloto),
		buffs = self.buffs,
		atkcnt = self.atkcnt,
		leftatkcnt = self.leftatkcnt,
		type = self.type,
		targettype = self.targettype,
		maxhp = self.maxhp,
		hp = self.hp,
		atk = self.atk
		crystalcost = self.crystalcost,
		magic_hurt = self.magic_hurt,
		recoverhp = self.recoverhp,
		magic_hurt_adden = self.magic_hurt_adden,
		hurt = self.hurt,
	}
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

function cwarcard:isdie()
	if self.__isdie then
		return true
	end
	-- after delcard
	if self.inarea == "graveyard" then
		return true
	end
	return false
end

function cwarcard:setdie()
	if not self.__isdie then
		logger.log("info","war",string.format("[warid=%d] #%d card.setdie,cardid=%d",self.warid,self.pid,self.id))
		self.__isdie = true
		local war = warmgr.getwar(self.warid)
		local warobj = war:getwarobj(self.pid)
		table.insert(warobj.diefootman,self)
		self:__ondie()
	end
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
	self:setleftatkcnt(self.atkcnt)
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onbeginround then
			cardcls.onbeginround(self,roundcnt)
		end
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
		table.remove(self.buffs,pos)
	end
end

function cwarcard:checkhalo()
	local owner = self:getowner()
	if self.halo.exceedround and self.halo.exceedround >= owner.roundcnt then
		self.halo = {}
		self.haloto = {}
	end
end

function cwarcard:onendround(hero)
	self:checkbuffs()
	self:checkhalo()
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

function cwarcard:onaddhp(hurtvalue,srcid)
	if not self:issilence() then
		local cardcls = getclassbycardsid(self.sid)
		if cardcls.onaddhp then
			cardcls.onaddhp(self,hurtvalue,srcid)
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
