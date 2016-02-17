--<<card 导表开始>>
local super = require "script.card.init"

ccard13510 = class("ccard13510",super,{
    sid = 13510,
    race = 3,
    name = "心灵视界",
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
    crystalcost = 1,
    targettype = 0,
    desc = "随机复制你的对手手牌中的一张牌,将其置入你的手牌。",
})

function ccard13510:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13510:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13510:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard13510:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if #warobj.enemy.leftcards > 0 then
		local cardsid = randlist(warobj.enemy.leftcards)
		warobj:putinhand(cardsid)
	end
end

return ccard13510
