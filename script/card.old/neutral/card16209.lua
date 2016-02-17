--<<card 导表开始>>
local super = require "script.card.init"

ccard16209 = class("ccard16209",super,{
    sid = 16209,
    race = 6,
    name = "船长的鹦鹉",
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
    type = 202,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：随机从你的牌库中将一张海盗牌置入你的手牌。",
})

function ccard16209:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16209:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16209:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16209:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitsids = {}
	local cardcls
	for _,sid in ipairs(warobj.leftcards) do
		cardcls = getclassbycardsid(sid)	
		if is_pirate_footman(cardcls.type) then
			table.insert(hitsids,sid)
		end
	end
	if #hitsids > 0 then
		local cardsid = randlist(hitsids)
		warobj:putinhand(cardsid)
	end
end

return ccard16209
