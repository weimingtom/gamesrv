--<<card 导表开始>>
local super = require "script.card.init"

ccard13305 = class("ccard13305",super,{
    sid = 13305,
    race = 3,
    name = "光明之泉",
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
    recoverhp = 3,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 5,
    crystalcost = 2,
    targettype = 0,
    desc = "在你的回合开始时,随机为一个受到伤害的友方角色恢复3点生命值。",
})

function ccard13305:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13305:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13305:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard13305:onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitids = {}
	for i,id in ipairs(warobj.warcards) do
		local warcard = warobj.id_card[id]
		if warcard:gethp() < warcard:getmaxhp() then
			table.insert(hitids,id)
		end
	end

	if warobj.hero:gethp() < warobj.hero:getmaxhp() then	
		table.insert(hitids,id)
	end
	if #hitids > 0 then
		local recoverhp = self:getrecoverhp()
		local id = randlist(hitids)
		if id == warobj.hero.id then
			warobj.hero:addhp(recoverhp,self.id)
		else
			local warcard = warobj.id_card[id]
			warcard:addhp(recoverhp,self.id)
		end
	end
end

return ccard13305
