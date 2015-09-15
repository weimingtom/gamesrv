--<<card 导表开始>>
local super = require "script.card.init"

ccard14303 = class("ccard14303",super,{
    sid = 14303,
    race = 4,
    name = "照明弹",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 1,
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
    crystalcost = 1,
    targettype = 0,
    desc = "使所有随从失去潜行效果。摧毁敌方所有奥秘。抽1张牌。",
})

function ccard14303:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14303:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14303:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14303:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local secretcards = warobj.enemy.secretcards
	for i,id in ipairs(secretcards) do
		warobj.enemy:delsecret(id,"destroy")
	end
	local warcard
	for i,id in ipairs(warobj.enemy.warcards) do
		warcard = warobj.enemy.id_card[id]
		if warcard:getstate("sneak") then
			warcard:delstate("sneak")
		end
	end
	for i,id in ipairs(warobj.warcards) do
		warcard = warobj.id_card[id]
		if warcard:getstate("sneak") then
			warcard:delstate("sneak")
		end
	end
	local cardsid = warobj:pickcard()
	warobj:putinhand(cardsid)
end

return ccard14303
