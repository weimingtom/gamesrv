--<<card 导表开始>>
local super = require "script.card"

ccard15401 = class("ccard15401",super,{
    sid = 15401,
    race = 5,
    name = "丛林之魂",
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
    desc = "使你的随从获得“亡语：召唤一个2/2的树人。”",
})

function ccard15401:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15401:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15401:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard15401:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	for i,id in ipairs(warobj.warcards) do
		local warcard = warobj.id_card[id]
		warcard:addeffect("ondie",{id=self.id,sid=self.sid,})
	end
end

function ccard15401:__ondie(warcard)
	local war = warmgr.getwar(self.warid)
	local warobj  = war:getwarobj(self.pid)
	local cardsid = isprettycard(self.sid) and 25604 or 15604
	local newwarcard = warobj:newwarcard(cardsid)
	warobj:putinwar(newwarcard,warcard.pos)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard15401
