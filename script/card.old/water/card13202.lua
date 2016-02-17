--<<card 导表开始>>
local super = require "script.card.init"

ccard13202 = class("ccard13202",super,{
    sid = 13202,
    race = 3,
    name = "控心术",
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
    crystalcost = 4,
    targettype = 0,
    desc = "随机复制对手的牌库中的一张随从牌,并将其置入战场。",
})

function ccard13202:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13202:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13202:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard13202:onuse(target)
	local war = warmgr.getwar(self.warid)	
	local warobj = war:getwarobj(self.pid)
	local enemy = warobj.enemy
	local validsids = {}
	for _,sid in ipairs(enemy.leftcards) do
		local cardcls = getclassbycardsid(sid)
		if is_footman(cardcls.type) then
			table.insert(validsids,sid)
		end
	end
	if #validsids > 0 then
		local sid = randlist(validsids)
		local warcard = warobj:newwarcard(sid)
		warobj:putinwar(warcard)
	end
end

return ccard13202
