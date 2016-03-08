--<<card 导表开始>>
local super = require "script.card.init"

ccard133002 = class("ccard133002",super,{
    sid = 133002,
    race = 3,
    name = "暗影狂乱",
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
    crystalcost = 4,
    targettype = 22,
    halo = nil,
    desc = "直到回合结束,获得一个攻击力小于或等于3的敌方随从的控制权。",
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

function ccard133002:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard133002:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard133002:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard133002:onuse(pos,targetid,choice)
	local owner = self:getowner()
	if owner:getfreespace("warcard") <= 0 then
		return
	end
	local target = onwer:gettarget(targetid)
	if target:getowner():removefromwar(target) then
		target.pid = owner.pid
		local effect = self:neweffect({
			name = "onendround",
		})
		local effectid = target:addeffect(effect)
		effect.callback = function (self)
			local owner = self:getowner()
			self:deleffectbyid(effectid)
			if owner.enemy:getfreespace("warcard") <= 0 then
				return
			end
			if owner:removefromwar(self) then
				owner.enemy:putinwar(self)
			end
		end
		owner:putinwar(target)
	end
end

return ccard133002
