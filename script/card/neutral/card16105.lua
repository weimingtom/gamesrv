--<<card 导表开始>>
local super = require "script.card"

ccard16105 = class("ccard16105",super,{
    sid = 16105,
    race = 6,
    name = "席尔瓦娜斯·风行者",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 1,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 5,
    hp = 5,
    crystalcost = 6,
    targettype = 0,
    desc = "亡语：控制一个随机敌方随从。",
})

function ccard16105:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16105:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16105:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"
function ccard16105:ondie()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if #warobj.enemy.warcards > 0 then
		local id = randlist(warobj.enemy.warcards)
		local warcard = warobj.enemy.id_card[id]
		warobj.enemy:removefromwar(warcard)
		warcard = warobj:clone(warcard)
		warobj:putinwar(warcard)
	end
end

return ccard16105
