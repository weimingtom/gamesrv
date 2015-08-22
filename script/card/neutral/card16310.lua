--<<card 导表开始>>
local super = require "script.card"

ccard16310 = class("ccard16310",super,{
    sid = 16310,
    race = 6,
    name = "奥秘守护者",
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
    hp = 2,
    crystalcost = 1,
    targettype = 0,
    desc = "每当有一张奥秘牌被揭示时,便获得+1/+1。",
})

function ccard16310:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16310:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16310:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard16310:onputinwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	register(warobj,"ontriggersecret",self.id)
	register(warobj.enemy,"ontriggersecret",self.id)
end

function ccard16310:onremovefromwar()
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	unregister(warobj,"ontriggersecret",self.id)
	unregister(warobj,"ontriggersecret",self.id)
end

function ccard16310:__ontriggersecret(secretcardid)
	self:addbuff({addatk=1,addmaxhp=1,},self.id,self.sid)
	return EVENTRESULT(IGNORE_NONE,IGNONE_NONE)
end

return ccard16310
