--<<card 导表开始>>
local super = require "script.card.init"

ccard16616 = class("ccard16616",super,{
    sid = 16616,
    race = 6,
    name = "我是鱼人",
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 0,
    desc = "召唤3只4只或5只1/1的鱼人",
})

function ccard16616:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16616:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16616:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16616:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardcls
	local hitsids = {}
	for _,sid in ipairs(waraux.fishcard) do
		cardcls = getclassbycardsid(sid)
		if cardcls.atk == 1 and cardcls.hp == 1 then
			table.insert(hitsids,sid)
		end
	end
	if #hitsids > 0 then
		local num = math.random(3,5)
		num = math.min(num,WAR_CARD_LIMIT-#warobj.warcards)
		for i = 1, num do
			local cardsid = randlist(hitsids)
			local warcard = warobj:newwarcard(cardsid)
			warobj:putinwar(warcard)
		end
	end
end

return ccard16616
