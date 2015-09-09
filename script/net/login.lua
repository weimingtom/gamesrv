local httpc = require "http.httpc"

require "script.db"
require "script.playermgr"
require "script.net"
require "script.loginqueue"
require "script.globalmgr"

netlogin = netlogin or {}
-- c2s
local REQUEST = {}
netlogin.REQUEST = REQUEST

--function REQUEST.register(obj,request)
--	local account = assert(request.account)
--	local passwd = assert(request.passwd)
--	local srvname = assert(request.srvname)
--	if not isvalid_accountname(account) then
--		return {result = "204 Invalid account format",}
--	end
--	if not isvalid_passwd(passwd) then
--		return {result = "205 Invalid password format"}
--	end
--	-- check srvname
--	local ac = db:get(db:key("account",account))		
--	if ac then
--		return {result="201 Account exist"}
--	else
--		ac = {
--			passwd = passwd,
--			srvname = srvname,
--			createtime = os.date("%Y-%m-%d %H:%M:%S"),
--			roles = {},
--		}
--		db:set(db:key("account",account),ac)
--		return {result="200 Ok"}
--	end
--end
--
--function REQUEST.login(obj,request)
--	local account = assert(request.account)
--	local passwd = assert(request.passwd)
--	local ac = db:get(db:key("account",account))
--	if not ac then
--		return {result = "202 Account nonexist"}
--	else
--		if ac.passwd ~= passwd then
--			return {result = "203 Password error"}
--		else
--			obj.account = account
--			obj.passwd = passwd
--			return {result= "200 Ok",roles=ac.roles}
--		end
--	end
--end
--
--function REQUEST.createrole(obj,request)
--	local account = assert(request.account)
--	local roletype = assert(request.roletype)
--	local name = assert(request.name)
--	if not isvalid_roletype(roletype) then
--		return {result = "301 Invalid roletype"}
--	end
--	if not isvalid_name(name) then
--		return {result = "302 Invalid name"}
--	end
--	local ac = db:get(db:key("account",account))
--	assert(ac,"Account nonexist")
--	local pid = playermgr.genpid()
--	local player = playermgr.createplayer(pid)
--	if not player then
--		return {result = "303 Over limit"}
--	end
--	player:create(request)	
--	local newrole = {
--		pid = player.pid,
--		name = name,
--		roletype = roletype,
--	}
--	table.insert(ac.roles,newrole)
--	db:set(db:key("account",account),ac)	
--	player:nowsave()
--	return {result = "200 Ok",newrole=newrole}
--end

local accountcenter = {
	host = "127.0.0.1:6000",
}

function REQUEST.register(obj,request)
	local account = assert(request.account)
	local passwd = assert(request.passwd)
	if not isvalid_accountname(account) then
		return {result=STATUS_ACCT_FMT_ERR}
	end
	if not isvalid_passwd(passwd) then
		return {result=STATUS_PASSWD_FMT_ERR}
	end
	local url = string.format("/register?acct=%s&passwd=%s&checkpasswd=%s",account,passwd,passwd)
	local status,body = httpc.get(accountcenter.host,url)
	if status == 200 then
		local result,body = unpackbody(body)
		if result == 0 then -- register success
				
		end
		return {result=result,}
	else
		return {result=status,}
	end
end

function REQUEST.login(obj,request)
	local account = assert(request.account)
	local passwd = assert(request.passwd)
	obj.account = account
	obj.passwd = passwd
	local url = string.format("/login?acct=%s&passwd=%s",account,passwd)
	logger.log("debug","test","start login")
	local status,body = httpc.get(accountcenter.host,url)
	logger.log("debug","test","after http request")
	if status == 200 then
		local result,body = unpackbody(body)
		if result == 0 then
			url = string.format("/rolelist?gameflag=%s&srvname=%s&acct=%s",cserver.gameflag,cserver.srvname,account)
			local status2,body2 = httpc.get(accountcenter.host,url)
			if status2 == 200 then
				local result2,body2 = unpackbody(body2)
				if result2 == 0 then
					obj.passlogin = true
					return {result=0,roles=body2.roles,}
				else
					return {result=result2}
				end
			else
				return {result=status2,}
			end
		else
			return {result=result,}
		end
	else
		return {result=status,}
	end
end

function REQUEST.createrole(obj,request)
	local account = assert(request.account)
	local roletype = assert(request.roletype)
	local name = assert(request.name)
	if not isvalid_roletype(roletype) then
		return {result=STATUS_ROLETYPE_INVALID}
	end
	if not isvalid_name(name) then
		return {result=STATUS_NAME_INVALID}
	end
	local pid = playermgr.genpid()
	local url = string.format("/createrole?gameflag=%s&srvname=%s&acct=%s&roleid=%s&name=%s&roletype=%s",cserver.gameflag,cserver.srvname,account,pid,name,roletype)
	local status,body = httpc.get(accountcenter.host,url)
	if status == 200 then
		local result,body = unpackbody(body)
		if result == 0 then	
			local player = playermgr.createplayer(pid)
			if not player then
				return {result = STATUS_OVERLIMIT,}
			end
			player:create(request)	
			local newrole = {
				roleid = player.pid,
				roletype = roletype,
				name = name,
				lv = 0,
			}
			player:nowsave()
            obj.passlogin = true
			return {result=result,newrole=newrole}
		else

			return {result=result}
		end
	else
		return {result=status}
	end
end


function REQUEST.entergame(obj,request)
	local roleid = assert(request.roleid)
	local token = request.token
	if not obj.passlogin then
		-- token auth
		if token then
			local v = playermgr.gettoken(token)
			if not v or v.pid ~= roleid then
				return {result=STATUS_UNAUTH}
			end
		else
			return {result=STATUS_UNAUTH}
		end
	end
	
	local oldplayer = playermgr.getplayer(roleid) 
	if obj == oldplayer then
		return {result = STATUS_REPEAT_LOGIN,}
	end
	local server = globalmgr.getserver()	
	if playermgr.onlinenum >= server.onlinelimit then
		loginqueue.push({pid=obj.pid,roleid=roleid})
		netlogin.queue(obj.pid,{waitnum=loginqueue.len()})
		return {result = STATUS_OVERLIMIT,}
	end
	if oldplayer then	-- 顶号
		net.msg.notify(oldplayer.pid,string.format("您的帐号被%s替换下线",gethideip(obj.__ip)))
		net.msg.notify(obj.pid,string.format("%s的帐号已被你替换下线",gethideip(oldplayer.__ip)))
		netlogin.kick(oldplayer.pid)
		playermgr.delobject(oldplayer.pid,"replace")
	end
	player = playermgr.recoverplayer(roleid)
	playermgr.transfer_mark(obj,player)
	playermgr.nettransfer(obj,player)
	player:entergame()
	return {result = STATUS_OK,}
end

function REQUEST.exitgame(player) 
	player:exitgame()
end



local RESPONSE = {}
netlogin.RESPONSE = RESPONSE




function netlogin.kick(pid)
	local player = playermgr.getplayer(pid)
	if player then
		local skynet = require "skynet"
		sendpackage(pid,"login","kick")
		skynet.send(player.__agent,"lua","kick",player.__fd)
	end	
end

function netlogin.queue(pid,package)
	sendpackage(pid,"login","queue",package)
end

function netlogin.reentergame(pid,package)
	sendpackage(pid,"login","reentergame",package)
end

return netlogin
