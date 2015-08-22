--<<card 导表开始>>
local super = require "script.card"

ccard16210 = class("ccard16210",super,{
    sid = 16210,
    race = 6,
    name = "血骑士",
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
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "战吼：所有随从失去圣盾。每有一个随从失去圣盾,便获得+3/+3。",
})

function ccard16210:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16210:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16210:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16210:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local num = 0
	local warcard
	for i,id in ipairs(warobj.warcards) do
		warcard = warobj.id_card[id]
		if warcard:getstate("shield") then
			warcard:delstate("shield")
			num = num + 1
		end
	end
	for i,id in ipairs(warobj.enemy.warcards) do
		warcard = warobj.enemy.id_card[id]
		if warcard:getstate("shield") then
			warcard:delstate("shield")
			num = num + 1
		end
	end
	if num > 0 then
		local buff = {addatk=3*num,addmaxhp=3*num,}
		self:addbuff(buff,self.id,self.sid)
	end
end

return ccard16210
