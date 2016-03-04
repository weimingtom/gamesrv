--<<card 导表开始>>
local super = require "script.card.init"

ccard144003 = class("ccard144003",super,{
    sid = 144003,
    race = 4,
    name = "食腐土狼",
    type = 202,
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
    atk = 2,
    maxhp = 2,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "每死1头野兽,获得+2/+1。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecorverhp = nil,
        onbeginround = nil,
        onendround = nil,
        ondelsecret = nil,
        onputinwar = nil,
        onremovefromwar = nil,
        onaddweapon = nil,
        onputinhand = nil,
        before_die = nil,
        after_die = {addbuff={addatk=2,addmaxhp=1,addhp=1}},
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

function ccard144003:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard144003:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard144003:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard144003:after_die(footman)
	if self.inarea ~= "war" then
		return
	end
	if footman.type ~= FOOTMAN.ANIMAL then
		return
	end
	local owner = self:getowner()
	if owner:isenemy(footman.id) then
		return
	end
	local buff = deepcopy(ccard144003.effect.after_die.addbuff)
	buff.srcid = footman.id
	buff.sid = footman.sid
	self:addbuff(buff)
end

return ccard144003
