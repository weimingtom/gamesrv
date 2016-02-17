--<<card 导表开始>>
local super = require "script.card.init"

ccard13302 = class("ccard13302",super,{
    sid = 13302,
    race = 3,
    name = "暗影狂乱",
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
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 0,
    crystalcost = 4,
    targettype = 22,
    desc = "直到回合结束,获得一个攻击力小于或等于3的敌方随从的控制权。",
})

function ccard13302:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard13302:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard13302:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

-- warcard
require "script.war.aux"
require "script.war.warmgr"

function ccard13302:onuse(target)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local enemy = warobj.enemy
	assert(enemy.id_card[target.id],"Invalid targetid:" .. tostring(target.id))

	target:oncheckdie()
	enemy:removefromwar(target)
	local newwarcard = warobj:clone(target)	
	warobj:putinwar(newwarcard)
	newwarcard:setleftatkcnt(newwarcard.atkcnt)
	if not warobj.tmp_warcards then
		warobj.tmp_warcards = {}
	end
	table.insert(warobj.tmp_warcards,newwarcard)
	register(warobj,"onendround",self.id)
end

function ccard13302:__onendround(roundcnt)
	local war = warmgr.getwar(self.warid)
	local warobj = war:getwarobj(self.pid)
	local enemy = warobj.enemy
	unregister(warobj,"onendround",self.id)
	if warobj.tmp_warcards then
		local list = warobj.tmp_warcards
		warobj.tmp_warcards = nil
		for _,tmpwarcard in ipairs(list) do
			if not tmpwarcard:isdie() then
				tmpwarcard:oncheckdie()
				warobj:removefromwar(tmpwarcard)
				local newwarcard = enemy:clone(tmpwarcard)
				enemy:putinwar(newwarcard)
			end
		end
	end
	return EVENTRESULT(IGNORE_NONE,IGNORE_NONE)
end

return ccard13302
