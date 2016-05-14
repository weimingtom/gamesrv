local snapshot = require "snapshot"

local S1 = snapshot()

local tmp = {}
local tmp2 = {
	key = "value",
	key1 = {}
}

local S2 = snapshot()
print(S1,tmp,tmp2,S2,_G)

for k,v in pairs(S2) do
	if S1[k] == nil then
		print(k,v)
	end
end

