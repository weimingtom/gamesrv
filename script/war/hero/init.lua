
require "script.war.warmgr"
require "script.war.aux"

chero = class("chero")

function chero.newhero(conf)
	require "script.war.hero.heromodule"
	pprintf("hero.conf:%s",conf)
	local race = conf.race
	local herocls = heromodule[race]
	return herocls.new(conf)
end

function chero:init(conf)
	self.id = conf.id
	self.pid = conf.pid
	self.warid = conf.warid
	self.race = conf.race
	self.maxhp = conf.maxhp
	self.skillcost = conf.skillcost
	self.hp = self.maxhp
	self.atk = 0
	self.def = 0
	self.atkcnt = 1
	self.leftatkcnt = 0
	self.buffs = {}
	self.state = {}
	self.type = 0
	self.onattack = {}
	self.ondefense = {}
	self.onaddhp = {}
	self.onhurt = {}
	self.onequipweapon = {}
	self.ondelweapon = {}
end

function chero:getweapon()
	return self.weapon
end

function chero:delweapon()
	warmgr.refreshwar(self.warid,self.pid,"delweapon",{id=self.id,})
	local cardid = self.weapon.id
	local war = warmgr.getwar(self.warid)
	local owner = war:getwarobj(self.pid)
	local card = owner.id_card[cardid]
	card:ondelweapon(self)
	self:__ondelweapon()
	self.weapon = nil
end


function chero:equipweapon(weapon)
	self.weapon = weapon
	warmgr.refreshwar(self.warid,self.pid,"equipweapon",{id=self.id,weapon=self.weapon,})
	self:setatkcnt(weapon.atkcnt)
	local cardid = weapon.id
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(cardid)
	local card = owner.id_card[cardid]
	card:onequipweapon(self)
	self:__onequipweapon()
end

function chero:addweaponusecnt(value,bcheck)
	self.weapon.usecnt = self.weapon.usecnt + value
	warmgr.refreshwar(self.warid,self.pid,"setweaponusecnt",{id=self.id,value=self.weapon.usecnt,})
	if bcheck then
		if self.weapon.usecnt <= 0 then
			self:delweapon()
		end
	end
end

function chero:addweaponatk(value)
	self.weapon.atk = self.weapon.atk + value
	warmgr.refreshwar(self.warid,self.pid,"setweaponatk",{id=self.id,value=self.weapon.atk})
end

function chero:useskill(target)
	local targetid
	if target then
		targetid = target.id
	end
	warmgr.refreshwar(self.warid,self.pid,"useskill",{id=self.id,targetid=targetid,})
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:check_die()
end

function chero:addleftatkcnt(value)
	local v = math.max(0,self.leftatkcnt + value)
	self:setleftatkcnt(v)
end

function chero:setleftatkcnt(atkcnt,nosync)
	local oldleftatkcnt = self.leftatkcnt
	if oldleftatkcnt ~= atkcnt then
		self.leftatkcnt = atkcnt
		if not nosync then
			warmgr.refreshwar(self.warid,self.pid,"setleftatkcnt",{id=self.id,value=self.leftatkcnt,})
		end
	end
end

function chero:setatkcnt(atkcnt,nosync)
	local oldatkcnt = self.atkcnt
	if oldatkcnt ~= atkcnt then
		self.atkcnt = atkcnt
		if not nosync then
			warmgr.refreshwar(self.warid,self.pid,"setatkcnt",{id=self.id,value=self.atkcnt,})
		end
		self:addleftatkcnt(atkcnt-oldatkcnt)
	end

end


function chero:addbuff(value,srcid,srcsid)
	local buff = {srcid=srcid,srcsid=srcsid,value=value}
	table.insert(self.buffs,buff)
	warmgr.refreshwar(self.warid,self.pid,"addbuff",{id=self.id,buff=buff,})
end

function chero:delbuff(srcid)
	local pos
	for i,v in ipairs(self.buffs) do
		if v.srcid == srcid then
			pos = i
			break
		end
	end
	local ret
	if pos then
		ret = table.remove(self.buffs,pos)
		warmgr.refreshwar(self.warid,self.pid,"delbuff",{id=self.id,srcid=srcid,})
	end
	return ret
end

function chero:setstate(type,newstate)	
	local oldstate = self.state[type]
	if oldstate ~= newstate then
		logger.log("debug","war",string.format("#%d hero.setstate,type=%s,state:%s->%s",self.pid,type,oldstate,newstate))
		self.state[type] = newstate
		warmgr.refreshwar(self.warid,self.pid,"setstate",{id=self.id,state=type,value=newstate,})
	end

end

function chero:getstate(type)
	return self.state[type]
end

function chero:delstate(type)
	local oldstate = self.state[type]
	if oldstate then
		logger.log("debug","war",string.format("#%d hero.delstate,type=%s",self.pid,type))
		self.state[type] = nil
		warmgr.refreshwar(self.warid,self.pid,"delstate",{id=self.id,state=type,})
	end
end

function chero:gethp()
	return self.hp
end

function chero:getmaxhp()
	return self.maxhp
end

function chero:getatk()
	local atk = self.atk
	local weapon = self:getweapon()
	if weapon then
		atk = atk + weapon.atk
	end
	return atk
end

function chero:gethurtvalue()
	return self:getatk()
end



function chero:addhp(value,srcid)
	local oldhp = self.hp
	logger.log("debug","war",string.format("[warid=%d] #%s hero.addhp, srcid=%d %d+%d",self.warid,self.pid,srcid,oldhp,value))
	if value > 0 then
		if self:__onaddhp(value) then
			return
		end
		self.hp = math.min(self.maxhp,self.hp+value)
	else
		-- 免疫状态回合结束时结算
		if self:getstate("immune") then
			return
		end
		value = -value
		if self.def > 0 then
			local subval = math.min(self.def,value)	
			value = value - subval
			self:adddef(-subval)
		end
		if value > 0 then
			if self:__onhurt(value,srcid) then
				return
			end
			self.hp = self.hp - value
		end
	end
	local newhp = self.hp
	if oldhp ~= newhp then
		warmgr.refreshwar(self.warid,self.pid,"sethp",{id=self.id,value=newhp,})
	end
	if self.hp <= 0 then
		self:setdie()
	end
end

function chero:adddef(value)
	self.def = self.def + value
	warmgr.refreshwar(self.warid,self.pid,"setdef",{id=self.id,value=self.def})
end

function chero:addatk(value,srcid)
	self.atk = self.atk + value
	warmgr.refreshwar(self.warid,self.pid,"setatk",{id=self.id,value=self.atk,})
end

function chero:setatk(value,srcid)
	self.atk = value
	warmgr.refreshwar(self.warid,self.pid,"setatk",{id=self.id,value=self.atk})
end


function chero:onbeginround(roundcnt)
	self:setleftatkcnt(self.atkcnt)
end

local lifecircle_states = {
	freeze = true,
	immune = true,
}
	
function chero:onendround(roundcnt)
	self:setatk(0,self.id)
	for state,_ in pairs(lifecircle_states) do
		local lifecircle = self:getstate(state)
		if lifecircle then
			lifecircle = lifecircle - 1
			if lifecircle <= 0 then
				self:delstate(state)
			else
				self:setstate(state,lifecircle)
			end
		end
	end
end

function chero:__ondefense(attacker)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.ondefense) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
		eventresult = cardcls.__ondefense(warcard,attacker,self)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
		if attacker:isdie() then
			break
		end
	end
	return ret
end

function chero:__onattack(target)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local owner,warcard,cardcls,eventresult
	local war = warmgr.getwar(self.warid)
	for i,id in ipairs(self.onattack) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
		eventresult = cardcls.__onattack(warcard,self,target)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
		if self:isdie() then
			break
		end
	end
	return ret
end

function chero:isdie()
	return self.__isdie
end

function chero:setdie()
	logger.log("debug","war",string.format("[warid=%d] #%d die",self.warid,self.pid))
	self.__isdie = true
end

function chero:__onaddhp(value)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.onaddhp) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
		eventresult = cardcls.__onaddhp(warcard,self,value)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end


function chero:__onhurt(hurtvalue,srcid)
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.onhurt) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
		eventresult = cardcls.__onhurt(warcard,self,hurtvalue,srcid)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function chero:__onequipweapon()
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.onequipweapon) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
		eventresult = cardcls.__onequipweapon(warcard,self)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end

function chero:__ondelweapon()
	local ret = false
	local ignoreevent = IGNORE_NONE
	local eventresult
	local owner,warcard,cardcls
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for _,id in ipairs(self.ondelweapon) do
		owner = war:getowner(id)
		warcard = owner.id_card[id]
		cardcls = getclassbycardsid(warcard.sid)
		eventresult = cardcls.__ondelweapon(warcard,self)
		if EVENTRESULT_FIELD1(eventresult) == IGNORE_ACTION then
			ret = true
		end
		ignoreevent = EVENTRESULT_FIELD2(eventresult)
		if ignoreevent == IGNORE_LATER_EVENT or ignoreevent == IGNORE_ALL_LATER_EVENT then
			break
		end
	end
	return ret
end


function chero:dump()
	local data = {}
	data.id = self.id
	data.pid = self.pid
	data.warid = self.warid
	data.maxhp = self.maxhp
	data.skillcost = self.skillcost
	data.hp = self.hp
	data.atk = self.atk
	data.def = self.def
	data.buffs = self.buffs
	data.state = self.state
	data.type = self.type
	data.ondefense = self.ondefense
	data.onattack = self.onattack
	data.onaddhp = self.onaddhp
	data.onhurt = self.onhurt
	return data
end

return chero
