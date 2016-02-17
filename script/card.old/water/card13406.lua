--<<card 导表开始>>
local super = require "script.card.init"

ccard13406 = class("ccard13406",super,{
    sid = 13406,
    race = 3,
    name = "思维窃取",
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
    targettype = 0,
    desc = "复制对手的牌库中的2张牌,并将其置入你的手牌。",
})

function ccard13406:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13406:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13406:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard13406:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local enemy = warobj.enemy
	local num = math.min(2,#enemy.leftcards)
	for i = 1, num do
		local cardsid = randlist(enemy.leftcards)
		warobj:putinhand(cardsid)
	end
end

return ccard13406
