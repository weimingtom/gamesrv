--<<card 导表开始>>
local super = require "script.card.init"

ccard13502 = class("ccard13502",super,{
    sid = 13502,
    race = 3,
    name = "神圣新星",
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
    magic_hurt = 2,
    recoverhp = 2,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 5,
    targettype = 0,
    desc = "对所有敌方角色造成2点伤害,为所有友方角色恢复2点生命值。",
})

function ccard13502:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13502:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13502:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"


function ccard13502:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue = self:gethurtvalue()
	local recoverhp = self:getrecoverhp()
	local warcard
	for _,id in ipairs(warobj.enemy.warcards) do
		warcard = warobj.enemy.id_card[id]
		warcard:addhp(-hurtvalue,self.id)
	end
	warobj.enemy.hero:addhp(-hurtvalue,self.id)
	for _,id in ipairs(warobj.warcards) do
		warcard = warobj.id_card[id]
		warcard:addhp(recoverhp,self.id)
	end
	warobj.hero:addhp(recoverhp,self.id)
end

return ccard13502
