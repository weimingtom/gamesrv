warsrvmgr = warsrvmgr or {}

function warsrvmgr.init()
	warsrvmgr.warsrvs = {}
	warsrvmgr.order_warsrv = {}
	warsrvmgr.lv_profiles = {}
	warsrvmgr.pid_profile = {}
	warsrvmgr.checkwarsrv()
	warsrvmgr.allocer()
end

-- 分配定时器
function warsrvmgr.allocer()
	timer.timeout("warsrvmgr.allocer",1,warsrvmgr.allocer)
	for lv,profiles in pairs(warsrvmgr.lv_profiles) do
		local profile1,profile2
		for _,profile in ipairs(profiles) do
			if profile.state == "ready" then
				if not profile1 then
					profile1 = profile
				else
					profile2 = profile
					break
				end
			end
		end
		if profile2 then
			local attacker,defenser
			if ishit(50,100) then
				attacker = profile1
				defenser = profile2
			else
				attacker = profile2
				defenser = profile1
			end
			warsrvmgr.onmatch(attacker,defenser)
			for _,warsrvname in ipairs(warsrvmgr.order_warsrv) do

				local ok,result = pcall(cluster.call,warsrvname,"war","createwar",attacker,defenser)
				if ok and result then
					break
				end
			end
		end
	end
end

function warsrvmgr.onmatch(profile1,profile2)
	logger.log("info","war",format("onmatch,%s -> %s",profile1,profile2))
	profile1.state = "match"
	profile2.state = "match"
	profile1.enemy_pid = profile2.pid
	profile2.enemy_pid = profile1.pid
end

-- 仅用于测试
function warsrvmgr.readyall()
	logger.log("warning","war","readyall")
	for lv,profiles in pairs(warsrvmgr.lv_profiles) do
		for i,profile in ipairs(profiles) do
			profile.state = "ready"
			profile.enemy_pid = nil
		end
	end
end


function warsrvmgr.addprofile(profile)
	local pid = assert(profile.pid)
	local lv = assert(profile.lv)
	profile.state = "ready"
	warsrvmgr.pid_profile[pid] = profile
	if not warsrvmgr.lv_profiles[lv] then
		warsrvmgr.lv_profiles[lv] = {}
	end
	table.insert(warsrvmgr.lv_profiles[lv],profile)
	profile.pos = #warsrvmgr.lv_profiles[lv]
end

function warsrvmgr.delprofile(pid)
	local profile = warsrvmgr.getprofile(pid)
	if profile then
		warsrvmgr.pid_profile[pid] = nil
		local pos = profile.pos
		table.remove(warsrvmgr.lv_profiles[profile.lv],pos)
	end
end

function warsrvmgr.getprofile(pid)
	return warsrvmgr.pid_profile[pid]
end

function warsrvmgr.checkwarsrv()
	timer.timeout("warsrvmgr.checkwarsrv",60,warsrvmgr.checkwarsrv)
	for srvname,_ in pairs(clustermgr.srvlist) do
		if cserver.iswarsrv(srvname) then
			local ok,result = pcall(cluster.call,srvname,"war","query_stat")
			if not ok then
				skynet.error(result)
			else
				local stat = result
				pprintf("srvname:%s,stat:%s",srvname,stat)
				stat.srvname = srvname
				warsrvmgr.warsrvs[srvname] = stat
			end
		end
	end
	warsrvmgr.order_warsrv = {}
	for srvname,stat in pairs(warsrvmgr.warsrvs) do
		table.insert(warsrvmgr.order_warsrv,srvname)
	end
	table.sort(warsrvmgr.order_warsrv,function (srvname1,srvname2)
		local v1 = warsrvmgr.warsrvs[srvname1]
		local v2 = warsrvmgr.warsrvs[srvname2]
		return v1.num < v2.num
	end)
end

local CMD = {}

-- gamesrv --> warsrvmgr
function CMD.search_opponent(source,player_profile)
	player_profile.srvname = source
	warsrvmgr.addprofile(player_profile)
end

function CMD.cancel_match(source,pid)
	local profile = warsrvmgr.getprofile(pid)
	if profile then
		if profile.state == "statwar" then
			local warid = assert(profile.warid)
			cluster.call(profile.warsrvname,"war","endwar",pid,warid)
		else
			warsrvmgr.delprofile(pid)
		end
	end
end

-- warsrv --> warsrvmgr
function CMD.startwar(source,request)
	assert(cserver.iswarsrv(source),"Not a warsrv:" .. tostring(source))
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local profile = warsrvmgr.getprofile(pid)
	profile.state = "startwar"
	profile.warsrvname = source
	profile.warid = warid
	local enemy_pid = profile.enemy_pid
	if enemy_pid then
		local enemy = assert(warsrvmgr.getprofile(enemy_pid))
		request.warsrvname = source
		request.enemy = enemy
		cluster.call(profile.srvname,"war","startwar",request)
	end

end


function CMD.endwar(source,request)
	assert(cserver.iswarsrv(source),"Not a warsrv:" .. tostring(source))
	local warid = assert(request.warid)
	local pid = assert(request.pid)
	local profile = warsrvmgr.getprofile(pid)
	warsrvmgr.delprofile(pid)
	profile.state = "endwar"
	cluster.call(profile.srvname,"war","endwar",request)
end



function warsrvmgr.dispatch(source,cmd,...)
	assert(type(source)=="string","Invalid srvname:" .. tostring(source))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(source,...)
end

return warsrvmgr
