--<<card 导表开始>>
local super = require "script.card"

ccard12304 = class("ccard12304",super,{
    sid = 12304,
    race = 2,
    name = "受祝福的勇士",
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
    crystalcost = 5,
    targettype = 32,
    desc = "使一个随从的攻击力翻倍。",
})

function ccard12304:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard12304:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard12304:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard12304:onuse(target)
	local atk = target:getatk()
	target:addbuff({addatk=atk,},self.id,self.sid)
end

return ccard12304
