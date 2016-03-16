--<<card 导表开始>>
local super = require "script.card.init"

ccard145001 = class("ccard145001",super,{
    sid = 145001,
    race = 4,
    name = "追踪术",
    type = 101,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
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
    atk = 0,
    maxhp = 0,
    crystalcost = 1,
    targettype = 0,
    halo = nil,
    desc = "查看你卡堆顶部的3张牌,抽取1张,弃掉其它2张。",
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

function ccard145001:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard145001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard145001:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard145001:onuse(pos,targetid,choice)
	local owner = self:getowner()
	local num = 3
	local ids = {}
	for i=1,num do
		local id = owner:pickcard()
		if id then
			table.insert(ids,id)
		end
	end
	owner.lookcards = ids
	warmgr.refreshwar(self.warid,self.pid,"lookcards",ids)
end

return ccard145001
