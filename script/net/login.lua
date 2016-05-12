
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
			logger.log("register",string.format("[register] account=%s passwd=%s ip=%s:%s",account,passwd,obj.__ip,obj.__port))
			obj.passlogin = true
		end
		return {result=result,}
	else
		return {result=status,}
	end
end

-- 调试登录模式：只允许登录本服角色
local function debuglogin(obj,request)
	local account = request.account
	local passwd = request.passwd
	if account:sub(1,1) == "#" then
		local pid = assert(tonumber(account:sub(2,-1)),account)
		--if passwd == "6c676c" then
		if passwd == "1" then
			obj.passlogin = true
			local player = playermgr.getplayer(pid)
			if not player then
				player = playermgr.loadofflineplayer(pid)
			end
			if not player then
				-- return STATUS_ROLE_NOEXIST
				return STATUS_OK,{}
			else
				obj.account = assert(player.account)
				return STATUS_OK,{
					{
						roleid = player.pid,
						name = player.name,
						lv = player.lv,
						roletype = player.roletype,
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
	local url = string.format("/login?acct=%s&passwd=%s&ip=%s",account,passwd,obj.__ip)
	local status,body = httpc.get(cserver.accountcenter.host,url)
	if status == 200 then
		local result,body = unpackbody(body)
		if result == 0 then
			obj.passlogin = true
			url = string.format("/rolelist?gameflag=%s&srvname=%s&acct=%s",cserver.gameflag,cserver.getsrvname(),account)
			local status2,body2 = httpc.get(cserver.accountcenter.host,url)
			if status2 == 200 then
				local result2,roles = unpackbody(body2)
				if result2 == STATUS_OK then
					return {result=STATUS_OK,roles=roles,}
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
	local url = string.format("/createrole?gameflag=%s&srvname=%s&acct=%s&roleid=%s",cserver.gameflag,cserver.getsrvname(),account,pid)
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
	local token_cache
	if not obj.passlogin then
		-- token auth
		if token then
			token_cache = playermgr.gettoken(token)
			if not token_cache or token_cache.pid ~= roleid then
				return {result=STATUS_UNAUTH}
			end
		else
			return {result=STATUS_UNAUTH}
		end
		obj.passlogin = true
	end
	
	local oldplayer = playermgr.getplayer(roleid) 
	if obj == oldplayer then
		return {result = STATUS_REPEAT_LOGIN,}
	end
	if not token then -- token认证登录不排队
		local server = globalmgr.server
		if playermgr.onlinenum >= server.onlinelimit then
			loginqueue.push({pid=obj.pid,roleid=roleid})
			netlogin.queue(obj.pid,{waitnum=loginqueue.len()})
			return {result = STATUS_OVERLIMIT,}
		end
	end
	if oldplayer then	-- 顶号
		local go_srvname
		-- token认证登录不检查：是否可以自动跳到跨服
		if not token and oldplayer.__state == "kuafu" and oldplayer.go_srvname then
			go_srvname = oldplayer.go_srvname
		end
		if oldplayer.__agent then -- 连线对象才提示，非连线对象可能有：离线对象/跨服对象
			net.msg.notify(oldplayer.pid,string.format("您的帐号被%s替换下线",gethideip(obj.__ip)))
			net.msg.notify(obj.pid,string.format("%s的帐号已被你替换下线",gethideip(oldplayer.__ip)))
		end
		netlogin.kick(oldplayer.pid,"replace")
		-- kick will delobject
		--playermgr.delobject(oldplayer.pid,"replace")
		if go_srvname then
			playermgr.gosrv(obj,go_srvname)
			return {result = STATUS_REDIRECT_SERVER,}
		end
	end
	local player = playermgr.recoverplayer(roleid)
	if token_cache and token_cache.home_srvname then
		local home_srvname = token_cache.home_srvname
		player.home_srvname = home_srvname
		player.player_data = token_cache.player_data
		local now_srvname = cserver.getsrvname()
		cluster.call(home_srvname,"rpc","playermgr.set_go_srvname",roleid,now_srvname)
	end
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
