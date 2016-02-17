--<<card 导表开始>>
local super = require "script.card.init"

ccard14404 = class("ccard14404",super,{
    sid = 14404,
    race = 4,
    name = "冰冻陷阱",
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
    crystalcost = 2,
    targettype = 0,
    desc = "奥秘：当1个敌对随从攻击时,让其返回到所有者手中,并令其消耗增加（2）",
})

function ccard14404:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14404:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14404:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14404:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:addsecret(self.id)
	register(warobj.enemy.footman,"onattack",self.id)
end

function ccard14404:__onattack(attacker,defenser)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	warobj:delsecret(self.id,"trigger")
	unregister(warobj.enemy.footman,"onattack",self.id)
	warobj.enemy:removefromwar(attacker)
	local warcard = warobj:putinhand(attacker.sid)
	warcard:addbuff({addcrystalcost=2,},self.id,self.sid)
	return EVENTRESULT(IGNORE_ACTION,IGNORE_NONE)
end

return ccard14404
