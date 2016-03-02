--<<card 导表开始>>
local super = require "script.card.init"

ccard143002 = class("ccard143002",super,{
    sid = 143002,
    race = 4,
    name = "误导",
    type = 102,
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 0,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    magic_hurt = 0,
    recoverhp = 0,
    cure_to_hurt = 0,
    recoverhp_multi = 1,
    magic_hurt_multi = 1,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 1,
    crystalcost = 2,
    targettype = 0,
    halo = nil,
    desc = "奥秘：当一个角色攻击你的英雄时,让他随机攻击另外一个角色取而代之。",
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
        before_addweapon = nil,
        after_addweapon = nil,
        before_delweapon = nil,
        after_delweapon = nil,
        before_putinwar = nil,
        after_putinwar = nil,
        before_removefromhand = nil,
        after_removefromhand = nil,
    },
})

function ccard143002:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard143002:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard143002:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

function ccard143002:before_attack(attacker,defenser)
	if self.inarea ~= "war" then
		return
	end
	local owner = self:getowner()
	if owner.hero.id == defenser.id then
		self:delsecret(self.id)	
		local allid = {}
		table.insert(allid,owner.hero.id)
		for i,id in ipairs(owner.warcards) do
			table.insert(allid,id)
		end
		table.insert(allid,owner.enemy.hero.id)
		for i,id in ipairs(owner.enemy.warcards) do
			table.insert(allid,id)
		end
		local id = randlist(allid)
		local target = owner:gettarget(id)
		attacker:getowner():__launchattack(attacker,target)
		return
	end
end

return ccard143002
