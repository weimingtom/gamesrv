--<<card 导表开始>>
local super = require "script.card.init"

ccard16315 = class("ccard16315",super,{
    sid = 16315,
    race = 6,
    name = "铸剑师",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    hp = 3,
    crystalcost = 2,
    targettype = 0,
    desc = "在你的回合结束时,随机使另一个友方随从获得+1攻击力。",
})

function ccard16315:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16315:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16315:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16315:onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitids = {}
	for i,id in ipairs(warobj.warcards) do
		if id ~= self.id then
			table.insert(hitids,id)
		end
	end
	if #hitids > 0 then
		local id = randlist(hitids)
		local warcard = warobj.id_card[id]
		warcard:addbuff({addatk=1,},self.id,self.sid)
	end
end

return ccard16315
