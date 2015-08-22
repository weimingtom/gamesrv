--<<card 导表开始>>
local super = require "script.card"

ccard16537 = class("ccard16537",super,{
    sid = 16537,
    race = 6,
    name = "暗鳞治愈者",
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
    recoverhp = 2,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 5,
    crystalcost = 5,
    targettype = 0,
    desc = "战吼：为所有友方角色恢复2点生命值。",
})

function ccard16537:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16537:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16537:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16537:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local warcard
	local recoverhp = self:getrecoverhp()
	for i,id in ipairs(warobj.warcards) do
		if id ~= self.id then
			warcard = warobj.id_card[id]
			warcard:addhp(recoverhp,self.id)
		end
	end
	warobj.hero:addhp(recoverhp,self.id)
end

return ccard16537
