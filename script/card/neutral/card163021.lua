--<<card 导表开始>>
local super = require "script.card.init"

ccard163021 = class("ccard163021",super,{
    sid = 163021,
    race = 6,
    name = "小鬼召唤师",
    type = 201,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 1,
    maxhp = 5,
    crystalcost = 3,
    targettype = 0,
    halo = nil,
    desc = "在你的回合结束时,对该随从造成1点伤害,并召唤一个1/1的小鬼。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecorverhp = nil,
        onbeginround = nil,
        onendround = {costhp=1,addfootman={166007,num=1}},
        ondelsecret = nil,
        onputinwar = nil,
        onremovefromwar = nil,
        onaddweapon = nil,
        onputinhand = nil,
        before_die = nil,
        after_die = nil,
        before_hurt = nil,
        after_hurt = nil,
        before_recoverhp = nil,
        after_recoverhp = nil,
        before_beginround = nil,
        after_beginround = nil,
        before_endround = nil,
        after_endround = nil,
        before_atttack = nil,
        after_attack = nil,
        before_playcard = nil,
        after_playcard = nil,
        before_putinwar = nil,
        after_putinwar = nil,
        before_removefromwar = nil,
        after_removefromwar = nil,
        before_addsecret = nil,
        after_addsecret = nil,
        before_delsecret = nil,
        after_delsecret = nil,
        before_addweapon = nil,
        after_addweapon = nil,
        before_delweapon = nil,
        after_delweapon = nil,
        before_putinhand = nil,
        after_putinhand = nil,
        before_removefromhand = nil,
        after_removefromhand = nil,
    },
})

function ccard163021:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard163021:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard163021:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard163021:onendround()
	local owner = self:getowner()
	local costhp = ccard163021.effect.onendround.costhp
	local sid = ccard163021.effect.onendround.addfootman.sid
	local num = ccard163021.effect.onendround.addfootman.num
	sid = togoldsidif(sid,is_goldcard(self.sid))
	self:addhp(-costhp,self.id)
	num = math.min(num,owner:getfreespace("warcard"))
	for i=1,num do
		local footman  = owner:newwarcard(sid)
		owner:putinwar(footman,self.pos)
	end
end

return ccard163021
