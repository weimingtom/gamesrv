

if not messagebox then
	messagebox = {
		id = 0,
		sessions = {},
	}
end

netmsg = netmsg or {}
-- c2s
local REQUEST = {}
netmsg.REQUEST = REQUEST

function REQUEST.onmessagebox(player,request)
	local id = request.id
	if id == 0 then
		return
	end
	local session = messagebox.sessions[id]
	if not session then
		return
	end
	local callback = session.callback
	callback(player,session.request,request.buttonid)	
end

local RESPONSE = {}
netmsg.RESPONSE = RESPONSE


-- s2c
function netmsg.notify(pid,msg)
	sendpackage(pid,"msg","notify",{msg=msg,})
end

--[[
function onbuysomething(player,request,buttonid)
	if buttonid == 1 then
		if not costok() then
			return
		end
		addres()
	end
end
netmsg.messagebox(10001,
				LACK_CONDITION,
				"条件不足",
				"是否花费100金币购买:",
				{
					chip = 1000,
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
					}
				},
				{
					"确认",
					"取消",
				},onbuysomething)
--]]


function netmsg.messagebox(pid,type,title,content,attach,buttons,callback)
	local id
	local request = {
		id = id,
		type = type,
		title = title,
		content = content,
		attach = attach,
		buttons = buttons,
	}

	if callback then
		if messagebox.id > MAX_NUMBER then
			messagebox.id = 0
		end
		messagebox.id = messagebox.id + 1
		messagebox.sessions[messagebox.id] = {
			request = request,
			callback = callback,
		}
		id = messagebox.id
	else
		id = 0
	end
	sendpackage(pid,"msg","messagebox",request)
end

function netmsg.bulletin(msg,func)
	for pid,_ in ipairs(playermgr.allplayer()) do
		if player then
			if not func or func(player) then
				netmsg.notify(pid,msg)
			end
		end
	end
end

return netmsg
