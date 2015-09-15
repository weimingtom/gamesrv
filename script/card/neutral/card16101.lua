--<<card 导表开始>>
local super = require "script.card.init"

ccard16101 = class("ccard16101",super,{
    sid = 16101,
    race = 6,
    name = "伊瑟拉",
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
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 4,
    hp = 12,
    crystalcost = 9,
    targettype = 0,
    desc = "在你的回合结束时,获得一张梦境牌。",
})

function ccard16101:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16101:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16101:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"


function ccard16101:onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitsids
	if isprettycard(self.sid) then
		hitsids = {26608,26609,26610,26611,26612,}
	else
		hitsids = {16608,16609,16610,16611,16612,}
	end
	local sid = randlist(hitsids)
	warobj:putinhand(sid)
end

return ccard16101
