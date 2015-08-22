--<<card 导表开始>>
local super = require "script.card"

ccard12510 = class("ccard12510",super,{
    sid = 12510,
    race = 2,
    name = "王者祝福",
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
    crystalcost = 4,
    targettype = 32,
    desc = "使一个随从获得+4/+4。（+4攻击力/+4生命值）",
})

function ccard12510:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12510:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12510:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12510:onuse(target)
	target:addbuff({addmaxhp=4,addatk=4,},self.id,self.sid)
end

return ccard12510
