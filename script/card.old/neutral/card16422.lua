--<<card 导表开始>>
local super = require "script.card.init"

ccard16422 = class("ccard16422",super,{
    sid = 16422,
    race = 6,
    name = "疯狂投弹者",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 3,
    hp = 2,
    crystalcost = 2,
    targettype = 0,
    desc = "战吼：造成3点伤害,随机由所有其他角色分摊。",
})

function ccard16422:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16422:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16422:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16422:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local hitids = {}
	for i,id in ipairs(warobj.warcards) do
		if id ~= self.id then
			table.insert(hitids,id)
		end
	end
	table.insert(hitids,warobj.hero.id)
	for i,id in ipairs(warobj.enemy.warcards) do
		table.insert(hitids,id)
	end
	table.insert(hitids,warobj.enemy.hero.id)
	local hurtvalue = 1
	for i = 1,3 do
		if warmgr.isgameover(self.warid) then
			return
		end
		if #hitids == 0 then
			break
		end
		local id,pos = randlist(hitids)	
		local target = warobj:gettarget(id)
		target:addhp(-hurtvalue,self.id)
		if target:isdie() then
			table.remove(hitids,pos)
		end
	end
end

return ccard16422
