-- TODO: DEL
--[[
	mergeserver step:
	1. remote connect
	2. loadfromdatabase
	3. change roleid
	4. local connect
	5. savetodatabase
]]

local pid_old_new = {}
local pid_new_old = {}
maxpid = nil
function genpid()
	local srvname = skynet.getenv("srvname")
	local conf = srvlist[srvname]
	maxpid = maxpid + 1
	print(maxpid,conf.maxroleid)
	if maxpid > conf.maxroleid then
		return nil
	end
	return maxpid
end

function connect(srv)
	db.shutdown()
	db.conn = db:connect({
		host = srv.ip,
		port = 6800,
		auth = "sundream",
		db = srv.db or 0,
		srvname = srv.srvname,
	})
	setmetatable(db,{__index = db.conn,})
	return db
end

function clear()
	for pid,_ in pairs(playermgr.allplayer()) do
		playermgr.delobject(pid)
	end
end

function loadfromdatabase()
	local allroleid = db:hkeys(db:key("role","list")) or {}
	for i,pid in ipairs(allroleid) do
		pid = tonumber(pid)
		local player = cplayer.new(pid)
		player.nosavetodatabase = true
		player:loadfromdatabase()
		local newpid = genpid()
		local oldpid = player.pid
		player.pid = newpid
		pid_old_new[oldpid] = newpid
		pid_new_old[newpid] = oldpid
		playermgr.addobject(player)
	end
	for newpid,player in pairs(playermgr.id_obj) do
		local oldpid = pid_new_old[newpid]
		local isok,result = pcall(onloadplayer,player,oldpid,newpid)
		local msg = string.format("mergeserver,oldpid=%d newpid=%d isok=%s result=%s",oldpid,newpid,isok,result)
		logger.log("info","mergeserver",msg)
		if not isok or true then
			print(msg)
		end
	end
end

function onloadplayer(player,oldpid,newpid)
	-- update pid
	player.pid = newpid
	for name,obj in pairs(player.autosaveobj) do
		if name == "time" then
			for k,o in pairs(obj.data) do
				o.pid = newpid
			end
		else
			obj.pid = newpid
		end
	end
	-- mail
	merge_mail(player,oldpid,newpid)
	-- friend
	merge_friend(player,oldpid,newpid)

	-- sync to frdsrv
	sync_to_frdsrv(player,oldpid,newpid)
	-- sync to accountcenter
	sync_to_accountcenter(player,oldpid,newpid)
end

-- may lost some friend relation
function sync_to_frdsrv(player,oldpid,newpid)
	local frdblk = player.frienddb:getfrdblk(oldpid)
	frdblk.pid = newpid
	frdblk:set("srvname",cserver.srvname,true)
	frdblk:sync(frdblk:save())
	cluster.call("frdsrv","friendmgr","updatepid",oldpid,newpid)
	cluster.call("frdsrv","friendmgr","delete",oldpid)
end

function sync_to_accountcenter(player,oldpid,newpid)
	local account = player:query("account")
	local gameflag = cserver.gameflag
	local url = string.format("/mergeserver?acct=%s&gameflag=%s&src_srvname=%s&dst_srvname=%s&oldroleid=%s&newroleid=%s",account,gameflag,src_srvname,dst_srvname,oldpid,newpid)
	local status,body = httpc.get("127.0.0.1:8001",url)
	logger.log("info","mergeserver",format("sync_to_accountcenter,url=%s status=%s body=%s",url,status,body))
end

function merge_mail(player,oldpid,newpid)
	local mailbox = mailmgr.loadmailbox(oldpid)	
	mailbox.nosavetodatabase = true
	mailbox.pid = newpid
	for mailid,mail in pairs(mailbox.mails) do
		mail.pid = newpid
		if mail.srcid > 100 then
			local src_newpid = pid_old_new[mail.srcid]
			mail.srcid = src_newpid
		end
	end
	mailmgr.mailboxs[newpid] = mailbox
end

function merge_friend(player,oldpid,newpid)
	local frienddb = player.frienddb
	local new_applyerlist = {}
	for i,pid in ipairs(frienddb.applyerlist) do
		if pid_old_new[pid] then
			table.insert(new_applyerlist,pid_old_new[pid])
		else
			table.insert(new_applyerlist,pid)
		end
	end
	frienddb.applyerlist = new_applyerlist
	local new_frdlist = {}
	for i,pid in ipairs(frienddb.frdlist) do
		if pid_old_new[pid] then
			table.insert(new_frdlist,pid_old_new[pid])
		else
			table.insert(new_frdlist,pid)
		end
	end
	frienddb.frdlist = new_frdlist
end


function savetodatabase()
	for pid,player in pairs(playermgr.id_obj) do
		player.nosavetodatabase = nil
		player:savetodatabase()
	end
	for pid,mailbox in pairs(mailmgr.mailboxs) do
		mailbox.nosavetodatabase = nil
		mailbox:savetodatabase()
	end
end

function updaterolelist()
	local db = dbmgr.getdb()
	db:set(db:key("role","maxroleid"),maxpid)
	for oldpid,newpid in pairs(pid_old_new) do
		db:hset(db:key("role","list"),newpid,1)
	end
end

src_srvname = nil
dst_srvname = nil

function mergeserver(src,dst)
	logger.log("info","mergeserver",string.format("mergeserver %s->%s start",src,dst))
	src_srvname = src
	dst_srvname = dst
	local src_srv = copy(assert(srvlist[src_srvname]))
	local dst_srv = copy(assert(srvlist[dst_srvname]))
	src_srv.srvname = src_srvname
	dst_srv.srvname = dst_srvname
	clear()
	maxpid = db:get(db:key("role","maxroleid"))
	connect(src_srv)
	loadfromdatabase()
	connect(dst_srv)
	savetodatabase()
	updaterolelist()
	logger.log("info","mergeserver",string.format("mergeserver %s->%s end",src,dst))
end
