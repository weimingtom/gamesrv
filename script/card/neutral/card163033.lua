--<<card 导表开始>>
local super = require "script.card.init"

ccard163033 = class("ccard163033",super,{
    sid = 163033,
    race = 6,
    name = "报警机器人",
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
    atk = 0,
    maxhp = 3,
    crystalcost = 3,
    targettype = 0,
    halo = nil,
    desc = "在你的回合开始时,随机将你的手牌中的一张随从牌与该随从交换。",
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

function ccard163033:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard163033:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard163033:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard163033:onbeginround()
	local owner = self:getowner()
	local ids = {}
	for i,id in ipairs(owner.handcards) do
		local handcard = owner:gettarget(id)
		if is_footman(handcard.type) then
			table.insert(ids,id)
		end
	end
	if not next(ids) then
		return
	end
	local id = randlist(ids)
	local handcard = owner:gettarget(id)
	if owner:removefromwar(self) then
		owner:removefromhand(handcard)
		owner:putinhand(self.id)
		owner:putinwar(handcard)
	end
end

return ccard163033
