--<<card 导表开始>>
local super = require "script.card"

ccard15304 = class("ccard15304",super,{
    sid = 15304,
    race = 5,
    name = "丛林守卫者",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
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
    atk = 2,
    hp = 4,
    crystalcost = 4,
    targettype = 32,
    desc = "抉择：造成2点伤害；或者沉默一个随从。",
})

function ccard15304:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15304:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15304:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15304:onuse(target)
	if self.choice == 1 then
		target:addhp(-2,self.id)
	elseif self.choice == 2 then
		target:silence()
	end
end

return ccard15304
