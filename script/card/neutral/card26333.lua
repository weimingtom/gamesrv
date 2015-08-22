--<<card 导表开始>>
local super = require "script.card.neutral.card16333"

ccard26333 = class("ccard26333",super,{
    sid = 26333,
    race = 6,
    name = "报警机器人",
    magic_immune = 0,
    assault = 0,
    sneer = 0,
    atkcnt = 1,
    shield = 0,
    warcry = 0,
    dieeffect = 0,
    secret = 0,
    sneak = 0,
    magic_hurt_adden = 0,
    type = 201,
    magic_hurt = 0,
    recoverhp = 0,
    max_amount = 2,
    composechip = 100,
    decomposechip = 10,
    atk = 0,
    hp = 3,
    crystalcost = 3,
    targettype = 0,
    desc = "在你的回合开始时,随机将你的手牌中的一张随从牌与该随从交换。",
})

function ccard26333:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26333:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26333:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26333
