--<<card 导表开始>>
local super = require "script.card.init"

ccard14504 = class("ccard14504",super,{
    sid = 14504,
    race = 4,
    name = "驯兽师",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 1,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 3,
    crystalcost = 4,
    targettype = 12,
    desc = "战吼：使1个友方野兽获得+2/+2和嘲讽。",
})

function ccard14504:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14504:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14504:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14504:onuse(target)
	target:addbuff({addatk=2,addmaxhp=2,},self.id,self.sid)
	target:setstate("sneer",1)
end

return ccard14504
