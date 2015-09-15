--<<card 导表开始>>
local super = require "script.card.init"

ccard15502 = class("ccard15502",super,{
    sid = 15502,
    race = 5,
    name = "野性印记",
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
    crystalcost = 2,
    targettype = 32,
    desc = "使1个随从获得嘲讽以及+2/+2。（+2攻击/+2生命）",
})

function ccard15502:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15502:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15502:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15502:onuse(target)
	target:addbuff({addatk=2,addmaxhp=2,},self.id,self.sid)
end
return ccard15502
