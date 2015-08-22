--<<card 导表开始>>
local super = require "script.card"

ccard16609 = class("ccard16609",super,{
    sid = 16609,
    race = 6,
    name = "梦魇",
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    hp = 0,
    crystalcost = 0,
    targettype = 32,
    desc = "使一名仆从获得+5/+5效果,下一轮开始前,该仆从将被摧毁。",
})

function ccard16609:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16609:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16609:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16609:onuse(target)
	target:addbuff({addatk=5,addmaxhp=5,},self.id,self.sid)
	target:addeffect("onbeginround",{id=self.id,sid=self.sid,})
end

function ccard16609:__onbeginround(warcard,roundcnt)
	local war = warmgr.getwar(warcard.warid)
	local warobj = war:getwarobj(warcard.pid)
	warobj:removefromwar(warcard)
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard16609
