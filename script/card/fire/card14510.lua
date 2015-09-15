--<<card 导表开始>>
local super = require "script.card.init"

ccard14510 = class("ccard14510",super,{
    sid = 14510,
    race = 4,
    name = "动物伙伴",
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
    desc = "随机召唤1头野兽宠物。",
})

function ccard14510:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard14510:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard14510:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard14510:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitsids
	if isprettycard(self.sid) then
		hitsids = {24603,24604,24605,}
	else
		hitsids = {14603,14604,14605,}
	end
	local sid = randlist(hitsids)
	local warcard = warobj:newwarcard(sid)
	warobj:putinwar(warcard)
end

return ccard14510
