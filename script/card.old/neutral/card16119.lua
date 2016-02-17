--<<card 导表开始>>
local super = require "script.card.init"

ccard16119 = class("ccard16119",super,{
    sid = 16119,
    race = 6,
    name = "格尔宾·梅尔托克",
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
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 6,
    hp = 6,
    crystalcost = 6,
    targettype = 0,
    desc = "战吼：进行一次惊人的发明。",
})

function ccard16119:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16119:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16119:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16119:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	if #warobj.warcards < WAR_CARD_LIMIT then
		local hitsids
		if isprettycard(self.sid) then
			hitsids = {26622,26623,26624,}
		else
			hitsids = {16622,16623,16624,}
		end
		local cardsid = randlist(hitsids)
		local warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard,self.pos+1)
	end
end


return ccard16119
