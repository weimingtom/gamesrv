--<<card 导表开始>>
local super = require "script.card.init"

ccard162001 = class("ccard162001",super,{
    sid = 162001,
    race = 6,
    name = "南海船长",
    type = 204,
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
    atk = 3,
    maxhp = 3,
    crystalcost = 3,
    targettype = 0,
    halo = {addatk=1,addmaxhp=1,addhp=1},
    desc = "你的其他海盗获得+1/+1。",
    effect = {
        onuse = nil,
        ondie = nil,
        onhurt = nil,
        onrecoverhp = nil,
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
        before_attack = nil,
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

function ccard162001:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard162001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard162001:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard162001:onputinwar(pos,reason)
	local owner = self:getowner()
	for i,id in ipairs(owner.warcards) do
		if id ~= self.id then
			local footman = owner:gettarget(id)
			if footman.type == FOOTMAN.HAIDAO then
				self:addhaloto(footman)
			end
		end
	end
end

function ccard162001:after_putinwar(footman,pos,reason)
	if self.inarea ~= "war" then
		return
	end
	if self.id == footman.id then
		return
	end
	if footman.type ~= FOOTMAN.HAIDAO then
		return
	end
	self:addhaloto(footman)
end

return ccard162001
