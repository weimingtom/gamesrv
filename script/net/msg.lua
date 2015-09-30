function starttimer_check_messagebox()
	timer.timeout("timer.check_messagebox",300,starttimer_check_messagebox)	
	local now = os.time()
	for id,session in pairs(messagebox.sessions) do
		if session.exceedtime and session.exceedtime <= now then
			messagebox.sessions[id] = nil
		end
	end
end


if not messagebox then
	messagebox = {
		id = 0,
		sessions = {},
	}
	starttimer_check_messagebox()
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
	messagebox.sessions[id] = nil
	local callback = session.callback
	if callback then
		callback(player,session.request,request.buttonid)	
	end
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
					ext = {
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
		attach = cjson.encode(attach),
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
			exceedtime = os.time() + 300,
		}
		id = messagebox.id
	else
		id = 0
	end
	sendpackage(pid,"msg","messagebox",request)
	request.attach = attach
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
