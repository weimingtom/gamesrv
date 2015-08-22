--<<card 导表开始>>
local super = require "script.card"

ccard12403 = class("ccard12403",super,{
    sid = 12403,
    race = 2,
    name = "崇高牺牲",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 101,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 1,
    targettype = 0,
    desc = "奥秘：每当一个敌人攻击时,召唤一个2/1的防御者,并使其成为攻击的目标。",
})

function ccard12403:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12403:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12403:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12403:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)	
	register(warobj.enemy.hero,"onattack",self.id)
	register(warobj.enemy.footman,"onattack",self.id)
end

function ccard12403:__onattack(attacker,defenser)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if #warobj.warcards < WAR_CARD_LIMIT then
		warobj:delsecret(self.id,"trigger")
		unregister(warobj.enemy.hero,"onattack",self.id)
		unregister(warobj.enemy.footman,"onattack",self.id)
		local cardsid = isprettycard(self.sid) and 22601 or 12601
		local target = warobj:newwarcard(cardsid)
		warobj:putinwar(target)
		if attacker.id == warobj.enemy.hero.id then
			local enemy_hero = warobj.enemy.hero
			warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=enemy_hero.id,targetid=target.id})
			target:addhp(-enmey_hero:getatk(),enemy_hero.id)
			enemy_hero:addhp(-target:getatk(),targetid)
			local weapon = enemy_hero:getweapon()
			if weapon then	
				if weapon.usecnt == 0 then
					enemy_hero:delweapon()
				end
			end
		else
			warmgr.refreshwar(self.warid,self.pid,"launchattack",{id=attacker.id,targetid=target.id,})
			target:addhp(-attacker:getatk(),attacker.id)
			attacker:addhp(-target:getatk(),target.id)
		end
		return EVENTRESULT(IGNORE_ACTION,IGNORE_NONE)
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard12403
