--<<card 导表开始>>
local super = require "script.card.init"

ccard13405 = class("ccard13405",super,{
    sid = 13405,
    race = 3,
    name = "治疗之环",
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
    recoverhp = 4,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 0,
    targettype = 0,
    desc = "为所有随从恢复4点生命值。",
})

function ccard13405:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13405:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13405:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function  ccard13405:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local recoverhp = self:getrecoverhp()
	local warcard
	for i,id in ipairs(warobj.warcards) do
		warcard = warobj.id_card[id]
		warcard:addhp(recoverhp,self.id)
	end
	for i,id in ipairs(warobj.enemy.warcards) do
		warcard = warobj.enemy.id_card[id]
		warcard:addhp(recoverhp,self.id)
	end
end

return ccard13405
