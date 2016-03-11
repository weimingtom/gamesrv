--<<cardbag 导表开始>>
local super = require "script.cardbag.init"
ccardbag1000 = class("ccardbag1000",super,{
    sid = 1000,
    name = "经典卡包",
    desc = "获取5张经典卡牌",
})

function ccardbag1000:init(conf)
    super.init(self,conf)
--<<cardbag 导表结束>>

end --导表生成

function ccardbag1000:load(data)
    if not data or not next(data) then
        return
    end
    super.load(self,data.data)
    -- todo: load data
end

function ccardbag1000:save()
    local data = {}
    data.data = super.save(self)
    -- todo: save data
    return data
end

return ccardbag1000
