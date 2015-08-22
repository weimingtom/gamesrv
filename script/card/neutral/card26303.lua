--<<card 导表开始>>
local super = require "script.card.neutral.card16303"

ccard26303 = class("ccard26303",super,{
    sid = 26303,
    race = 6,
    name = "年轻的女祭司",
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
    atk = 2,
    hp = 1,
    crystalcost = 1,
    targettype = 0,
    desc = "在你的回合结束时,使另一个随机友方随从获得+1生命值。",
})

function ccard26303:init(pid)
    super.init(self,pid)
    self.data = {}
--<<card 导表结束>>

end --导表生成

function ccard26303:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccard26303:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccard26303
