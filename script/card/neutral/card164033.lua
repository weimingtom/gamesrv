--<<card 导表开始>>
local super = require "script.card.init"

ccard164033 = class("ccard164033",super,{
    sid = 164033,
    race = 6,
    name = "恐狼前锋",
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
    halo = {addatk=1},
    desc = "相邻的随从获得+1攻击力。",
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

function ccard164033:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard164033:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard164033:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard164033:rehaloto()
	self:clearhaloto()
	local pos = self.pos
	local owner = self:getowner()
	local left_id = owner.warcards[pos-1]
	local right_id = owner.warcards[pos+1]
	if left_id then
		local left_target = owner:gettarget(left_id)
		self:addhaloto(left_target)
	end
	if right_id then
		local right_target = owner:gettarget(right_id)
		self:addhaloto(right_target)
	end
end

function ccard164033:onputinwar(pos,reason)
	self:rehaloto()
end

function ccard164033:after_putinwar(footman,pos,reason)
	if self.inarea ~= "war" then
		return
	end
	if math.abs(self.pos-footman.pos) ~= 1 then
		return
	end
	self:rehaloto()
end

function ccard164033:after_removefromwar(footman)
	if self.inarea ~= "war" then
		return
	end
	if not self.haloto[footman.id] then
		return
	end
	self:rehaloto()
end

return ccard164033
