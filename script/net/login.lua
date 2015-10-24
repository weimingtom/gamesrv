
netlogin = netlogin or {}
-- c2s
local REQUEST = {}
netlogin.REQUEST = REQUEST

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
	local status,body = httpc.get(cserver.accountcenter.host,url)
	if status == 200 then
		local result,body = unpackbody(body)
		if result == 0 then -- register success
			obj.passlogin = true	
		end
		return {result=result,}
	else
		return {result=status,}
	end
end

local function debuglogin(obj,request)
	local account = request.account
	local passwd = request.passwd
	if account:sub(1,1) == "#" then
		local pid = assert(tonumber(account:sub(2,-1)),account)
		if passwd == "6c676c" then
			obj.passlogin = true
			local resume = resumemgr.getresume(pid)
			if not resume then
				-- return STATUS_ROLE_NOEXIST
				return STATUS_OK,{}
			else
				obj.account = assert(resume:query("account"))
				return STATUS_OK,{
					{
						roleid = pid,
						name = resume.name,
						lv = resume.lv,
						roletype = resume.roletype,
					}
				}
			end
		end
		return STATUS_PASSWD_NOMATCH
	end
	return false
end

function REQUEST.login(obj,request)
	local account = assert(request.account)
	local passwd = assert(request.passwd)
	obj.account = account
	obj.passwd = passwd
	if skynet.getenv("mode") == "debug" then
		local result,roles = debuglogin(obj,request)	
		if result then
			return {result=result,roles=roles}
		end
	end
	local url = string.format("/login?acct=%s&passwd=%s",account,passwd)
	local status,body = httpc.get(cserver.accountcenter.host,url)
	if status == 200 then
		local result,body = unpackbody(body)
		if result == 0 then
			obj.passlogin = true
			url = string.format("/rolelist?gameflag=%s&srvname=%s&acct=%s",cserver.gameflag,cserver.srvname,account)
			local status2,body2 = httpc.get(cserver.accountcenter.host,url)
			if status2 == 200 then
				local result2,roles = unpackbody(body2)
				if result2 == STATUS_OK then
					return {result=STATUS_OK,roles=values(roles),}
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

local function debugcreaterole(obj,request)
	local account = assert(obj.account or request.account)
	local roletype = assert(request.roletype)
	local name = assert(request.name)
	if account:sub(1,1) == "#" then
		local pid = assert(tonumber(account:sub(2,-1)),account)
		local newrole = {
			roleid = pid,
			roletype = roletype,
			name = name,
			lv = 0,
			gold = 0,
		}
		local player = playermgr.createplayer(pid,{
			account = account,
			roletype = roletype,
			name = name,
			__ip = obj.__ip,
			__port = obj.__port,
		})
		return STATUS_OK,newrole
	end
	return false
end

function REQUEST.createrole(obj,request)
	local account = assert(obj.account or request.account)
	local roletype = assert(request.roletype)
	local name = assert(request.name)
	if not obj.passlogin then
		return {result=STATUS_UNAUTH}
	end
	if not isvalid_roletype(roletype) then
		return {result=STATUS_ROLETYPE_INVALID}
	end
	if not isvalid_name(name) then
		return {result=STATUS_NAME_INVALID}
	end
	-- 调试模式下允许不经过帐号中心直接创建角色
	if skynet.getenv("mode") == "debug" then
		local result,newrole = debugcreaterole(obj,request)
		if result then
			return {result=result,newrole=newrole}
		end
	end
	local pid = playermgr.genpid()
    if not pid then
		return {result = STATUS_OVERLIMIT,}
    end
	local newrole = {
		roleid = pid,
		roletype = roletype,
		name = name,
		lv = 0,
		gold = 0,
	}
	local url = string.format("/createrole?gameflag=%s&srvname=%s&acct=%s&roleid=%s",cserver.gameflag,cserver.srvname,account,pid)
	local data = cjson.encode(newrole)
	local status,body = httpc.get(cserver.accountcenter.host,url,nil,nil,data)
	if status == 200 then
		local result,body = unpackbody(body)
		if result == 0 then	
			local player = playermgr.createplayer(pid,{
				account = account,
				roletype = roletype,
				name = name,
				__ip = obj.__ip,
				__port = obj.__port,
			})
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
	local server = globalmgr.server
	if playermgr.onlinenum >= server.onlinelimit then
		loginqueue.push({pid=obj.pid,roleid=roleid})
		netlogin.queue(obj.pid,{waitnum=loginqueue.len()})
		return {result = STATUS_OVERLIMIT,}
	end
	if oldplayer then	-- 顶号
		net.msg.notify(oldplayer.pid,string.format("您的帐号被%s替换下线",gethideip(obj.__ip)))
		net.msg.notify(obj.pid,string.format("%s的帐号已被你替换下线",gethideip(oldplayer.__ip)))
		netlogin.kick(oldplayer.pid,"replace")
		-- kick will delobject
		--playermgr.delobject(oldplayer.pid,"replace")
	end
	local player = playermgr.recoverplayer(roleid)
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
		sendpackage(pid,"login","kick")
		playermgr.kick(pid)
	end	
end

function netlogin.queue(pid,package)
	sendpackage(pid,"login","queue",package)
end

function netlogin.reentergame(pid,package)
	sendpackage(pid,"login","reentergame",package)
end

return netlogin
