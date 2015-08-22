--<<card 导表开始>>
local super = require "script.card"

ccard14302 = class("ccard14302",super,{
    sid = 14302,
    race = 4,
    name = "误导",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 1,
    crystalcost = 2,
    targettype = 0,
    desc = "奥秘：当一个角色攻击你的英雄时,让他随机攻击另外一个角色取而代之。",
})

function ccard14302:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14302:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14302:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14302:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.hero,"ondefense",self.id)
end

function ccard14302:__ondefense(attacker,defenser)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	assert(defenser == warobj.hero)
	local hitids = {}
	for i,id in ipairs(warobj.enemy.warcards) do
		if id ~= attacker.id then
			table.insert(hitids,id)
		end
	end
	if warobj.enemy.hero.id ~= attacker.id then
		table.insert(hitids,warobj.enemy.hero.id)
	end
	for i,id in ipairs(warobj.warcards) do
		table.insert(hitids,id)	
	end
	if #hitids > 0 then
		warobj:delsecret(self.id,"trigger")
		unregister(warobj.hero,"ondefense",self.id)
		local id = randlist(hitids)
		local target = warobj:gettarget(id)
		if attacker.id == warobj.enemy.hero.id then
			warmgr.refreshwar(self.warid,attacker.pid,"launchattack",{id=attacker.id,targetid=target.id,})	
			-- target is footman
			attacker:addhp(-target:getatk(),target.id)
			target:addhp(-attacker:getatk(),attacker.id)
		else
			warmgr.refreshwar(self.warid,attacker.pid,"launchattack",{id=attacker.id,targetid=target.id,})
			if target.id == warobj.enemy.hero.id then
				warobj.enemy.hero:addhp(-attacker:getatk(),self.id)
			else
				attacker:addhp(-target:getatk(),target.id)
				target:addhp(-attacker:getatk(),attacker.id)
			end
		end
		return EVENTRESULT(IGNORE_ACTION,IGNORE_NONE)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard14302
