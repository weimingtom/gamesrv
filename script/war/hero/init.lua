
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
	self.name = conf.name
	self.maxhp = conf.maxhp or 30
	self.def = conf.def or 0
	self.skillcost = conf.skillcost or 2
	self.hp = self.maxhp
	self.atk = 0
	self.atkcnt = 1
	self.leftatkcnt = 0
	self.weapon = nil
	self.anyin = 0 -- 0:非暗影形态，1--暗影形态，2--高级暗影形态（英雄技能造成3点伤害)
end

function chero:canattack()
	if self:has("freeze") then
		return false
	end
	local atk = self:getatk()
	if atk <= 0 then
		return false
	end
	if self.leftatkcnt <= 0 then
		return false
	end
	return true
end

function cwarcard:addleftatkcnt(addval)
	local leftatkcnt = self.leftatkcnt + addval
	leftatkcnt = math.min(self.atkcnt,math.max(0,leftatkcnt))
	warmgr.refreshwar(self.warid,self.pid,"synchero",{
		id = self.id,
		leftatkcnt = self.leftatkcnt,
	})
end

function chero:getowner(id)
	id = id or self.id
	local war = warmgr.getwar(self.warid)
	local card = self:gettarget(id)
	if card.pid == war.attacker.pid then
		return war.attacker
	else
		assert(card.pid == war.defenser.pid)
		return war.defenser
	end
end

function chero:getatk()
	local weapon = self.weapon
	return self.atk + (weapon and weapon:getatk() or 0)
end

function chero:gete4e()
	return 0
end

function chero:isstate(state)
	return VALID_STATE[state]
end

function chero:getstate(state)
	return self[state]
end

function chero:hasstate(state)
	local state = self:getstate(state) or 0
	return state > 0
end

function chero:setstate(state,val)
	val = val == 0 and val or val + self.roundcnt
	local oldval = self[state] or 0
	if val == oldval then
		return
	end
	if val == 0 or val > oldval then
		self[state] = val
		warmgr.refreshwar(self.warid,self.pid,"updatehero",{
			id = self.id,
			[state] = val,
		})
	end
end

function chero:checkstate()
	local updateattrs = {}
	for k,_ in pairs(VALID_STATE) do
		local exceedround = self[k]
		if exceedround then
			if exceedround ~= 0 and exceedround <= self.roundcnt then
				self[k] = 0
				updateattrs[k] = self[k]
			end
		end
	end
	if next(updateattrs) then
		updateattrs.id = self.id
		warmgr.refreshwar(self.warid,self.pid,"updatehero",updateattrs)
	end
end

function chero:setanyin(isopen)
	if not isopen then
		self.anyin = 0
	else
		if self.anyin == 1 then
			self.anyin = 2
		else
			self.anyin = 1
		end
	end
	warmgr.refreshwar(self.warid,self.pid,"updatehero",{
		id = self.id,
		anyin = self.anyin,
	})
end

function chero:addmaxhp(addval)
	self.maxhp = self.maxhp + addval
	self.hp = math.min(self.hp,self.maxhp)
	warmgr.refreshwar(self.warid,self.pid,"updatehero",{
		id = self.id,
		maxphp = self.maxhp,
		hp = self.hp,
	})
end

function chero:setmaxhp(value)
	self.maxhp = value
	self.hp = math.min(self.hp,self.maxhp)
	warmgr.refreshwar(self.warid,self.pid,"updatehero",{
		id = self.id,
		maxhp = self.maxhp,
		hp = self.hp,
	})
end

function chero:sethp(value)
	self.hp = value
	self.hp = math.min(self.hp,self.maxhp)
	warmgr.refreshwar(self.warid,self.pid,"updatehero",{
		id = self.id,
		hp = self.hp,
	})	
end

function chero:addhp(value,srcid)
	if value == 0 then
		return 0
	end
	local ret
	if value < 0 then
		ret = self:costhp(-value,srcid)
	else
		ret = self:recoverhp(value,srcid)
	end
	warmgr.refreshwar(self.warid,self.pid,"updatehero",{
		id = self.id,
		hp = self.hp,
	})
	return ret
end

function chero:costhp(value,srcid)
	assert(value > 0)
	local owner = self:getowner()
	if not owner:before_hurt(self,value,srcid) then
		return 0
	end
	self.hp = math.max(0,self.hp-value)
	if self.hp <= 0 then
		self:die()
	end
	owner:after_hurt(self,value,srcid)
	return value
end

function chero:recoverhp(value,srcid)
	assert(value > 0)
	local recoverhp = math.min(value,self.maxhp-self.hp)
	if recoverhp > 0 then
		local owner = self:getowner()
		if not owner:before_recoverhp(self,recoverhp,srcid) then
			return 0
		end
		self.hp = self.hp + recoverhp
		owner:after_recoverhp(self,recoverhp,srcid)
	end
	return recoverhp
end

function chero:adddef(addval)
	self.def = self.def + addval
	warmgr.refreshwar(self.warid,self.pid,"updatehero",{
		id = self.id,
		def = self.def,
	})
end

function chero:addatk(addval)
	self.atk = self.atk + addval
	self.atk = math.max(0,self.atk)
	warmgr.refreshwar(self.warid,self.pid,"updatehero",{
		id = self.id,
		atk = self.atk,
	})
end

function chero:delweapon()
	if self.weapon then
		local weapon = self.weapon
		self.weapon = nil
		weapon:die()
	end
end

function chero:addweapon(weapon)
	if self.weapon then
		self:delweapon()
	end
	self.weapon = weapon
end

function chero:useskill(targetid)
end

function chero:onbeginround()
	self:checkstate()
	self.atk = 0
	self.leftatkcnt = self.atkcnt
	warmgr.refreshwar(self.warid,self.pid,"synchero",{
		id = self.id,
		atk = self.atk,
		leftatkcnt = self.leftatkcnt,
	})
end

function chero:onendround()
	self:checkstate()
	self.atk = 0
	warmgr.refreshwar(self.warid,self.pid,"synchero",{
		id = self.id,
		atk = self.atk,
	})
end

function chero:execute(cmd,...)
	local func = self[cmd]
	if func then
		return func(...)
	end
end

return chero
