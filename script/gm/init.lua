require "script.skynet"

local AUTH_SUPERADMIN = 100
local AUTH_ADMIN = 90
local AUTH_PROGRAMER = 80
local AUTH_DESIGNER = 70
local AUTH_NORMAL = 10

gm = gm or {}
master = nil

local function getcmd(cmds,cmd)
	if cmds[cmd] then
		return cmd
	end
	cmd = string.lower(cmd)
	for k,v in pairs(cmds) do
		if string.lower(k) == cmd then
			return k
		end
	end
end

local function getfunc(cmds,cmd)
	if cmds[cmd] and type(cmds[cmd]) == "function" then
		return cmds[cmd]
	end
	cmd = string.lower(cmd)
	for k,v in pairs(cmds) do
		if type(v) == "function" and string.lower(k) == cmd then
			return v
		end
	end
end

local function docmd(player,cmdline)
	local cmd,leftcmd = string.match(cmdline,"([%w_]+)%s*(.*)")
	local authority
	if type(player) == "number" then
		authority = AUTH_SUPERADMIN
	else
		authority = player:authority()
	end
	if cmd then
		local func,need_auth
		if authority == AUTH_SUPERADMIN or authority == AUTH_ADMIN then
			func = getfunc(gm,cmd)
			need_auth = 0
		else
			for auth,cmds in pairs(gm.CMD) do
				cmd = getcmd(cmds,cmd)
				if cmd then
					func = getfunc(gm,cmd)
					if func then
						need_auth = auth
						break
					end
				end
			end
		end
		if func then
			if authority >= need_auth then
				local args = {}
				if leftcmd then
					for arg in string.gmatch(leftcmd,"[^%s]+") do
						table.insert(args,arg)
					end
				end
				return func(args)
			else
				return string.format("authority not enough(%d < %d)",authority,need_auth)
			end
		else
			if authority >= AUTH_ADMIN then
				func = load(cmdline,"=(load)","bt")
				return func()
			else
				return "unknow cmd:" .. tostring(cmdline)
			end
		end
	else
		return "cann't parse cmdline:" .. tostring(cmdline)
	end
end

function gm.docmd(pid,cmdline)
	local authority
	local player
	if pid ~= 0 then
		player = playermgr.getplayer(pid)
		if not player then
			player = playermgr.loadofflineplayer(pid)
		end
		authority = player:authority()
	else
		player = 0
	end
	master = player
	--local tbl = {xpcall(docmd,onerror,player,cmdline)}
	-- gm指令执行的报错不记录到onerror.log中
	local tbl = {pcall(docmd,player,cmdline)}
	master = nil
	local issuccess = table.remove(tbl,1)
	local result
	if next(tbl) then
		for i,v in ipairs(tbl) do
			tbl[i] = mytostring(v)
		end
		result = table.concat(tbl,",")
	end
	logger.log("info","gm",format("[gm.docmd] pid=%s authority=%s cmd='%s' issuccess=%s result=%s",pid,authority,cmdline,issuccess,result))
	if pid ~= 0 then
		net.msg.notify(pid,string.format("执行%s\n%s",issuccess and "成功" or "失败",result))
	end
	return issuccess,result
end

--- cmd: setauthority
--- usage: setauthority pid authority
--- e.g. : setauthority 10001 80 # 将玩家10001权限设置成80(权限范围:[1,100])
function gm.setauthority(args)
	local master_pid
	local master_auth
	if type(master) == "number" then -- oscmd
		master_pid = master
		master_auth = AUTH_SUPERADMIN
	else
		master_pid = master.pid
		master_auth = master:authority()
	end
	local ok,args = pcall(checkargs,args,"int:[10000,]","int:[1,100]")
	if not ok then
		net.msg.notify(master.pid,"usage: setauthority pid authorit")
		return
	end
	local pid,authority = table.unpack(args)	
	local player = playermgr.getplayer(pid)
	if not player then
		net.msg.notify(master_pid,string.format("玩家(%d)不在线,无法对其进行此项操作",pid))
		return
	end
	if master_pid == player.pid then
		net.msg.notify(master_pid,"无法给自己设置权限")
		return
	end
	local auth = master:authority()
	local target_auth = player:authority()
	if authority > master_auth then
		net.msg.notify(master_pid,string.format("权限不足,设定的权限大于自己拥有的权限(%d>%d)",authority,master_auth))
	end
	if master_auth <= target_auth then
		net.msg.notify(master_pid,"权限不足,自身权限没有目标权限高")
		return
	end
	if target_auth == AUTH_SUPERADMIN then
		net.msg.notify(master_pid,"警告:你无法对超级管理员设定权限")
		return
	end
	if authority == AUTH_SUPERADMIN then
		net.msg.notify(master_pid,"警告:你无法将他人设置成超级管理员")
		return
	end
	logger.log("info","authority",string.format("[gm.setauthority] pid=%d authority=%d tid=%d authority=%d->%d",master_pid,master_auth,pid,target_auth,authority))
	player:setauthority(authority)
end

gm.CMD = {
	[AUTH_SUPERADMIN] = {
	},
	[AUTH_ADMIN] = {
	},
	[AUTH_PROGRAMER] = {
	},
	[AUTH_DESIGNER] = {
	},
	[AUTH_NORMAL] = {
		setauthority = true,
		buildgmdoc = true,
	},
}

function gm.init()
	require "script.gm.sys"
	require "script.gm.helper"
	require "script.gm.card"
	require "script.gm.test"
	require "script.gm.other"
end

function __hotfix(oldmod)
	gm.init()
	gm.__doc = nil
end

return gm
