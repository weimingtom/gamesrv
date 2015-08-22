--<<card 导表开始>>
local super = require "script.card"

ccard15406 = class("ccard15406",super,{
    sid = 15406,
    race = 5,
    name = "自然印记",
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
    targettype = 32,
    desc = "抉择：使一个随从获得+4攻击力；或者+4生命值并具有嘲讽。",
})

function ccard15406:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15406:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15406:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15406:onuse(target)
	if self.choice == 1 then
		target:addbuff({addatk=4,},self.id,self.sid)
	elseif self.choice == 2 then
		target:addbuff({addmaxhp=4,},self.id,self.sid)
		target:setstate("sneer",1)
	end
end

return ccard15406
