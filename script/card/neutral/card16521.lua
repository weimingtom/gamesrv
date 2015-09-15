--<<card 导表开始>>
local super = require "script.card.init"

ccard16521 = class("ccard16521",super,{
    sid = 16521,
    race = 6,
    name = "破碎残阳祭司",
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
    atk = 3,
    hp = 2,
    crystalcost = 3,
    targettype = 12,
    desc = "战吼：使一个友方随从获得+1/+1。",
})

function ccard16521:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16521:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16521:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16521:onuse(target)
	target:addbuff({addatk=1,addmaxhp=1,},self.id,self.sid)
end
return ccard16521
