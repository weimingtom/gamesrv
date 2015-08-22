--<<card 导表开始>>
local super = require "script.card"

ccard16102 = class("ccard16102",super,{
    sid = 16102,
    race = 6,
    name = "工匠大师欧沃斯巴克",
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
    max_amount = 1,
    composechip = 100,
    decomposechip = 10,
    atk = 2,
    hp = 2,
    crystalcost = 3,
    targettype = 32,
    desc = "战吼：使另一个随机随从变形成为一个5/5的恐龙或一个1/1的松鼠。",
})

function ccard16102:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard16102:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard16102:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end


-- warcard
require "script.war.aux"
require "script.war.warmgr"


function ccard16102:onuse(target)
	local war = warmgr.getwar(self.warid)
	local owner = war:getowner(target.id)
	local pos = target.pos
	local sid = isprettycard(self.sid) and randlist({26613,26614,}) or randlist({16613,16614,})

	owner:removefromwar(target)
	local warcard = owner:newwarcard(sid)
	owner:putinwar(warcard,pos)
end

return ccard16102
