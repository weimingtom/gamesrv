--<<card 导表开始>>
local super = require "script.card.init"

ccard15201 = class("ccard15201",super,{
    sid = 15201,
    race = 5,
    name = "自然之力",
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
    crystalcost = 6,
    targettype = 0,
    desc = "召唤3个2/2并具有冲锋的树人,在回合结束时,消灭这些树人。",
})

function ccard15201:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard15201:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard15201:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
function ccard15201:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local cardsid = isprettycard(self.sid) and 25604 or 15604
	local num = math.min(3,WAR_CARD_LIMIT - #warobj.warcards)
	if not self.tmp_summon_footman then
		self.tmp_summon_footman = {}
	end
	for i = 1,num do
		local warcard = warobj:newwarcard(cardsid)
		warobj:putinwar(warcard)
		warcard:setstate("assault",1)
		table.insert(self.tmp_summon_footman,warcard.id)
	end
	register(warobj,"onendround",self.id)
end

function ccard15201:__onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"onendround",self.id)
	local tmp = self.tmp_summon_footman
	self.tmp_summon_footman = {}
	for i,id in ipairs(tmp) do
		local warcard = warobj.id_card[id]
		if warcard then
			warobj:removefromwar(warcard)
		end
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end



return ccard15201
