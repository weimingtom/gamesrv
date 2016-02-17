--<<card 导表开始>>
local super = require "script.card.init"

ccard15507 = class("ccard15507",super,{
    sid = 15507,
    race = 5,
    name = "野蛮咆哮",
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
    hp = 0,
    crystalcost = 3,
    targettype = 0,
    desc = "在本回合中,使你的所有角色获得+2攻击力。",
})

function ccard15507:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15507:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15507:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15507:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local warcard
	for i,id in ipairs(warobj.warcards) do
		warcard = warobj.id_card[id]
		warcard:addbuff({addatk=2,lifecircle=1},self.id,self.sid)
	end
	warobj.hero:addatk(2)
end
return ccard15507