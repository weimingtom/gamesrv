--<<card 导表开始>>
local super = require "script.card.init"

ccard16623 = class("ccard16623",super,{
    sid = 16623,
    race = 6,
    name = "侏儒变鸡器",
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
    type = 206,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 3,
    crystalcost = 1,
    targettype = 0,
    desc = "在你回合的开始阶段,将随机一名随从变成一只1/1的小鸡。",
})

function ccard16623:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16623:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16623:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16623:onbeginround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitids = {}
	for i,id in ipairs(warobj.warcards) do
		table.insert(hitids,id)
	end
	for i,id in ipairs(warobj.enemy.warcards) do
		table.insert(hitids,id)
	end
	if #hitids > 0 then
		local id = randlist(hitids)
		local owner = war:getowner(id)
		local warcard = owner.id_card[id]
		owner:removefromwar(warcard)
		local cardsid = isprettycard(self.sid) and 26330 or 16330
		local newwarcard = owner:newwarcard(cardsid)
		owner:putinwar(newwarcard,warcard.pos)
	end
end

return ccard16623
