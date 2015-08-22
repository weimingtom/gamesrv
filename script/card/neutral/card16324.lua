--<<card 导表开始>>
local super = require "script.card"

ccard16324 = class("ccard16324",super,{
    sid = 16324,
    race = 6,
    name = "阿古斯防御者",
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
    atk = 2,
    hp = 3,
    crystalcost = 4,
    targettype = 0,
    desc = "战吼：使相邻的随从获得+1/+1和嘲讽。",
})

function ccard16324:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16324:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16324:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16324:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local pos = self.pos
	local id = warobj.warcards[pos-1]
	if id then
		local footman = warobj.id_card[id]
		footman:addbuff({addatk=1,addmaxhp=1,},self.id,self.sid)
		footman:setstate("snear",1)
	end
	local id = warobj.warcards[pos+1]
	if id then
		local footman = warobj.id_card[id]
		footman:addbuff({addatk=1,addmaxhp=1,},self.id,self.sid)
		footman:setstate("snear",1)
	end
end

return ccard16324
