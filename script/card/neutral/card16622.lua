--<<card 导表开始>>
local super = require "script.card.init"

ccard16622 = class("ccard16622",super,{
    sid = 16622,
    race = 6,
    name = "修理机器人",
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
    recoverhp = 6,
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 3,
    crystalcost = 1,
    targettype = 0,
    desc = "在你回合的结束阶段,为一个受到伤害的角色回复6点生命值。",
})

function ccard16622:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16622:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16622:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16622:onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local warcard
	local hitids = {}
	for i,id in ipairs(warobj.warcards) do
		warcard = warobj.id_card[id]
		if warcard:gethp() < warcard:getmaxhp() then
			table.insert(hitids,id)
		end
	end
	if warobj.hero:gethp() < warobj.hero:getmaxhp() then
		table.insert(hitids,id)
	end
	for i,id in ipairs(warobj.enemy.warcards) do
		warcard = warobj.id_card[id]
		if warcard:gethp() < warcard:getmaxhp() then
			table.insert(hitids,id)
		end
	end
	if warobj.enemy.hero:gethp() < warobj.enemy.hero:getmaxhp() then
		table.insert(hitids,id)
	end
	local recoverhp = self:getrecoverhp()
	local id = randlist(hitids)
	if id == warobj.hero.id then
		warobj.hero:addhp(recoverhp,self.id)
	elseif id == warobj.enemy.hero.id then
		warobj.enemy.hero:addhp(recoverhp,self.id)
	else
		local owner = war:getowner(id)
		warcard = owner.id_card[id]
		warcard:addhp(recoverhp,self.id)
	end
end

return ccard16622
