require "script.award"

local function onbuysomething(player,request,buttonid)
	if buttonid == 1 then -- confirm
		local costgold = request.attach.extra.gold
		if not player:validpay("gold",costgold,true) then
			return
		end
		doaward(player.pid,request.attach,true,"test")
	end
end

local function test(pid,choice)
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	print("online")
	local request = {
		title = "条件不足",
		content = "是否花费100金币购买:",
		attach = {
			chip = 100,
			items = {
				{
					itemid = 14101,
					num = 3,
				},
				{
					itemid = 14201,
					num = 2,
				},
			},
			extra = {
				gold = 100,
			},
		},
		buttons = {
			"确认",
			"取消",
		},
	}
	if choice == 1 then
		net.msg.messagebox(pid,request.title,request.content,request.attach,request.buttons,onbuysomething)	
	elseif choice == 2 then
		onbuysomething(player,request,1)
	end
end

return test
