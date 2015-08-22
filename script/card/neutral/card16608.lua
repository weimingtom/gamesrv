--<<card 导表开始>>
local super = require "script.card"

ccard16608 = class("ccard16608",super,{
    sid = 16608,
    race = 6,
    name = "伊瑟拉的觉醒",
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
    magic_hurt = 5,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 2,
    targettype = 0,
    desc = "对除了伊瑟拉以外的全部角色造成5点伤害",
})

function ccard16608:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16608:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16608:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"
function ccard16608:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hurtvalue = 5
	local warcard
	for i,id in ipairs(warobj.warcards) do
		warcard = warobj.id_card[id]
		if warcard.sid ~= 16101 and warcard.sid ~= 26101 then
			warcard:addhp(-hurtvalue,self.id)
		end
	end
	warobj.hero:addhp(-hurtvalue,self.id)
	for i,id in ipairs(warobj.enemy.warcards) do
		warcard = warobj.enemy.id_card[id]
		if warcard.sid ~= 16601 and warcard.sid ~= 26101 then
			warcard:addhp(-hurtvalue,self.id)
		end
	end
	warobj.enemy.hero:addhp(-hurtvalue,self.id)
end

return ccard16608
