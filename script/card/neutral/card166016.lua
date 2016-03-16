--<<card 导表开始>>
local super = require "script.card.init"

ccard166016 = class("ccard166016",super,{
    sid = 166016,
    race = 6,
    name = "我是鱼人",
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
    max_amount = 0,
    composechip = 0,
    decomposechip = 0,
    atk = 0,
    maxhp = 0,
    crystalcost = 4,
    targettype = 0,
    halo = nil,
    desc = "召唤3只4只或5只1/1的鱼人",
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

function ccard166016:init(conf)
    super.init(self,conf)
--<<card 导表结束>>

end --导表生成

function ccard166016:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data)
    -- todo: load data
end

function ccard166016:save()
    local data = super.save(self)
    -- todo: save data
    return data
end

function ccard166016:onuse()
	local owner = self:getowner()
	local num = randlist({3,4,5})
	num = math.min(num,owner:getfreespace("warcard"))
	local cards = getcards("1/1的鱼",function (cardcls)
		if is_footman(cardcls.type) and cardcls.type == FOOTMAN.FISH then
			if cardcls.maxhp == 1 and cardcls.atk == 1 then
				return true
			end
		end
		return false
	end)
	for i=1,num do
		local sid = randlist(cards)
		local footman = owner:newwarcard(sid)
		owner:putinwar(footman)
	end
end


return ccard166016
