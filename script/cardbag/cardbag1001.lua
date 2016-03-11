--<<cardbag 导表开始>>
local super = require "script.cardbag.init"
ccardbag1001 = class("ccardbag1001",super,{
    sid = 1001,
    name = "机器卡包",
    desc = "获取5张机器类型卡牌",
})

function ccardbag1001:init(conf)
    super.init(self,conf)
--<<cardbag 导表结束>>

end --导表生成

function ccardbag1001:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccardbag1001:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccardbag1001
