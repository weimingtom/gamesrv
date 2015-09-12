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
			if ishit(50,100) then
				profile1.isattacker = true
			else
				profile1,profile2 = profile2,profile1
				profile1.isattacker = true
			end
			profile1.state = "match"
			profile2.state = "match"
			warsrvmgr.onmatch(profile1,profile2)
			for _,warsrvname in ipairs(warsrvmgr.order_warsrv) do
				local ok,result = pcall(cluster.call,warsrvname,"war","createwar",profile1,profile2)
				if ok and result then
					break
				end
			end
		end
	end
end

function warsrvmgr.onmatch(profile1,profile2)
	profile1.lastmatch = profile2.pid
	profile2.lastmatch = profile1.pid

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
			local ok,result = pcall(cluster.call,srvname,"war","query_profile")
			if not ok then
				skynet.error(result)
			else
				local profile = result
				pprintf("srvname:%s,profile:%s",srvname,profile)
				profile.srvname = srvname
				warsrvmgr.warsrvs[srvname] = profile
			end
		end
	end
	for srvname,profile in pairs(warsrvmgr.warsrvs) do
		table.insert(warsrvmgr.order_warsrv,srvname)
	end
	table.sort(warsrvmgr.order_warsrv,function (srvname1,srvname2)
		local v1 = warsrvmgr.warsrvs[srvname1]
		local v2 = warsrvmgr.warsrvs[srvname2]
		return v1.num < v2.num
	end)
end

function warsrvmgr.startwar(warsrvname,pid,warid)
	local profile = warsrvmgr.getprofile(pid)
	profile.state = "startwar"
	profile.warsrvname = warsrvname
	profile.warid = warid
	local matcher_profile = warsrvmgr.getprofile(profile.lastmatch)
	print(profile.lastmatch,matcher_profile)
	if matcher_profile then
		cluster.call(profile.srvname,"war","startwar","fight",pid,warsrvname,warid,matcher_profile)
	end
end

function warsrvmgr.endwar(warsrvname,pid,warid,result)
	local profile = warsrvmgr.getprofile(pid)
	warsrvmgr.delprofile(pid)
	profile.state = "endwar"
	if result == 1 then --win
		profile.wincnt = profile.wincnt + 1
		profile.consecutive_wincnt = profile.consecutive_wincnt + 1
		profile.consecutive_failcnt = 0
	elseif result == 0 then --fail
		profile.failcnt = profile.failcnt + 1
		profile.consecutive_failcnt = profile.consecutive_failcnt + 1
		profile.consecutive_wincnt = 0
	else
		-- tie
	end
	lastmatch = warsrvmgr.getprofile(profile.lastmatch)
	cluster.call(profile.srvname,"war","endwar","fight",pid,profile.warsrvname,warid,result,profile,lastmatch)	
end





local CMD = {}

-- gamesrv --> warsrvmgr
function CMD.search_opponent(srvname,player_profile)
	player_profile.srvname = srvname
	warsrvmgr.addprofile(player_profile)
end

function CMD.cancel_match(srvname,pid)
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
function CMD.startwar(srvname,pid,warid)
	assert(cserver.iswarsrv(srvname),"Not a warsrv:" .. tostring(srvname))
	warsrvmgr.startwar(srvname,pid,warid)
end


function CMD.endwar(srvname,pid,warid,result)
	assert(cserver.iswarsrv(srvname),"Not a warsrv:" .. tostring(srvname))
	warsrvmgr.endwar(srvname,pid,warid,result)
end



function warsrvmgr.dispatch(srvname,cmd,...)
	assert(type(srvname)=="string","Invalid srvname:" .. tostring(srvname))
	local func = assert(CMD[cmd],"Unknow cmd:" .. tostring(cmd))
	return func(srvname,...)
end

return warsrvmgr
