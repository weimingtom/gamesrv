
local BUFF_TYPE = 0
local HALO_TYPE = 1

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
	:
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

function cwarcard:__get(buffs,attr,maxinorder)
	maxinorder = maxinorder or 0
	for i=#buffs,1,-1 do
		local v = buffs[i]
		if v.inorder > maxinorder and v[attr] then
			return v[attr],v.inorder
		end
	end
end

function cwarcard:getfromhalo(owner,attr,maxinorder)
	-- 光环(取最后进入战场卡牌光环效果)
	maxinorder = maxinorder or 0
	local val
	if owner.hero.weapon then
		local warcard = owner.hero.weapon
		if warcard.haloto[self.id] and warcard.inorder > maxinorder  then
			if warcard.halo[attr] then
				maxinorder = warcard.inorder
				val = warcard.halo[attr]
			end
		end
	end

	for i,id in ipairs(owner.secretcards) do
		local warcard = owner.id_card[id]
		if warcard.haloto[self.id] and warcard.inorder > maxinorder then
			if warcard.halo[attr] then
				maxinorder = warcard.inorder
				val = warcard.halo[attr]
			end
		end
	end
	for i,id in ipairs(owner.warcards) do
		local warcard = owner.id_card[id]
		if warcard.haloto[self.id] and warcard.inorder > maxinorder then
			if warcard.halo[attr] then
				maxinorder = warcard.inorder
				val = warcard.halo[attr]
			end
		end
	end
	return val,maxinorder
end

function cwarcard:__get2(buffs,attr,maxinorder)
	maxinorder = maxinorder or 0
	local sum = 0
	for i,v in ipairs(buffs) do
		if v[attr] and v.inorder > maxinorder then
			sum = sum + v[attr]
		end
	end
	return sum
end

function cwarcard:getfromhalo2(owner,attr,maxinorder)
	maxinorder = maxinorder or 0
	local sum = 0
	if owner.hero.weapon then
		local warcard = owner.hero.weapon
		if warcard.haloto[self.id] and warcard.inorder > maxinorder then
			if warcard.halo[attr] then
				sum = sum + warcard.halo[attr]
			end
		end
	end

	for i,id in ipairs(owner.secretcards) do
		local warcard = owner.id_card[id]
		if warcard.haloto[self.id] and warcard.inorder > maxinorder then
			if warcard.halo[attr] then
				sum = sum + warcard.halo[attr]
			end
		end
	end
	for i,id in ipairs(owner.warcards) do
		local warcard = owner.id_card[id]
		if warcard.haloto[self.id] and warcard.inorder > maxinorder then
			if warcard.halo[attr] then
				sum = sum + warcard.halo[attr]
			end
		end
	end
	return sum
end

-- 获取属性值：取最后施加BUFF/光环设置的值
function cwarcard:get(attr,init_maxinorder)
	init_maxinorder = init_maxinorder or 0
	local owner = self:getowner()
	local buff_val,maxinorder = self:__get(self.buffs,attr,init_maxinorder)
	local halo_val,halo_maxinorder = self:getfromhalo(owner,attr,maxinorder)
	local enemy_halo_val,enemy_halo_maxinorder = self:getfromhalo(owner.enemy,"enemy_" .. attr,halo_maxinorder)
	local val = enemy_halo_val or halo_val or buff_val
	if val then
		return val,enemy_halo_maxinorder
	end
	return self[attr],0
end


-- 得到增加（累积）的属性，如：addatk
function cwarcard:get2(attr,maxinorder)
	maxinorder = maxinorder or 0
	local owner = self:getowner()
	local self_buff_add = self:__get2(self.buffs,attr,maxinorder)
	local self_halo_add = self:getfromhalo2(owner,attr,maxinorder)
	local enemy_halo_add = self:getfromhalo2(owner.enemy,"enemy_" .. attr,maxinorder)
	return self_halo_add + enemy_halo_add + self_buff_add + (self[attr] or 0)
end

function cwarcard:has(attr)
	local val = self:get(attr)
	if type(val) ~= "boolean" then
		return val == YES
	else
		return val
	end
end

function cwarcard:set(attr,val)
	local oldval = self:get(attr)
	if oldval ~= val then
		self[attr] = val
		self:onupdate(attr,oldval,val)
	end
end


function cwarcard:getatk()
	-- 光耀之子：攻击力==生命值
	if self.sid == 134002 or self.sid == 234002 then
		if not self.bsilence then
			return self:gethp()
		end
	end
	local atk,maxinorder = self:get("atk")
	local val = atk + self:get2("addatk",maxinorder)
	local minval = self:get("minatk") or 0
	local maxval = self:get("maxatk") or MAX_NUMBER
	return math.max(minval,math.min(val,maxval))
end

function cwarcard:getmaxhp()
	local maxhp,maxinorder = self:get("maxhp")
	local val = maxhp = self:get2("addmaxhp",maxinorder)
	local minval = self:get("minmaxhp") or 0
	local maxval = self:get("maxmaxhp") or MAX_NUMBER
	return math.max(minval,math.min(val,maxval))
end

function cwarcard:getcrystalcost()
	local crystalcost,maxinorder = self:get("crystalcost")
	local val = crystalcost + self:get2("addcrystalcost",maxinorder)
	local minval = self:get("mincrystalcost") or 0
	local maxval = self:get("maxcrystalcost") or MAX_NUMBER
	return math.max(minval,math.min(val,maxval))
end

function cwarcard:get_magic_hurt_adden()
	local magic_hurt_adden,maxinorder = self:get("magic_hurt_adden")
	return magic_hurt_adden + self:get2("add_magic_hurt_adden",maxinorder)
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
