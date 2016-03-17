
require "script.card.init"
require "script.card.cardlib"
require "script.card.cardtablelib"
require "script.cardbag.cardbaglib"
require "script.friend.frienddb"
require "script.achieve.achievedb"
require "script.task.taskmgr"
require "script.item.itemdb"

cplayer = class("cplayer",cdatabaseable)

function cplayer:init(pid)
	self.flag = "cplayer"
	cdatabaseable.init(self,{
		pid = pid,
		flag = self.flag,
	})
	-- resume
	self.pid = pid
	self.name = nil
	self.account = nil
	self.lv = nil
	self.viplv = nil
	self.roletype = nil
	self.gold = nil
	self.chip = nil

	self.data = {}
	self.cardlib = ccardlib.new(self.pid)
	self.cardtablelib = ccardtablelib.new(self.pid)
	self.cardbaglib = ccardbaglib.new(self.pid)
	self.frienddb = cfrienddb.new(self.pid)
	self.achievedb = cachievedb.new(self.pid)
	self.today = ctoday.new{
		pid = self.pid,
		flag = self.flag,
	}
	self.thistemp = cthistemp.new{
		pid = self.pid,
		flag = self.flag,
	}
	self.thisweek = cthisweek.new{
		pid = self.pid,
		flag = self.flag,
	}
	self.thisweek2 = cthisweek2.new{
		pid = self.pid,
		flag = self.flag,
	}
	self.timeattr = cattrcontainer.new{
		today = self.today,
		thistemp = self.thistemp,
		thisweek = self.thisweek,
		thisweek2 = self.thisweek2,
	}
	self.taskmgr = ctaskmgr.new(self.pid)
	self.itemdb = citemdb.new(self.pid)
	self.autosaveobj = {
		time = self.timeattr,
		card = self.cardlib,
		cardtablelib = self.cardtablelib, 
		cardbaglib = self.cardbaglib,
		friend = self.frienddb,
		achieve = self.achievedb,
		task = self.taskmgr,
		item = self.itemdb,
	}

	self.loadstate = "unload"

	self.savename = string.format("%s.%s",self.flag,self.pid)
	autosave(self)
end

function cplayer:save()
	local data = {}
	data.data = self.data
	data.resume = self:packresume()
	data.basic = {
		teamid = self.teamid,
		sceneid = self.sceneid,
		pos = self.pos,
		warstate = self.warstate,
	}
	return data
end


function cplayer:load(data)
	if not data or not next(data) then
		logger.log("error","error",string.format("cplayer:load null,pid=%d",self.pid))
		return
	end
	self.data = data.data
	self:unpackresume(data.resume)
	if data.basic then
		self.teamid = data.basic.teamid
		self.sceneid = data.basic.sceneid
		self.pos = data.basic.pos
		self.warstate = data.basic.warstate
	end
end

function cplayer:packresume()
	local resume = {
		gold = self.gold,
		chip = self.chip,
		viplv = self.viplv,
		account = self.account,
		name = self.name,
		lv = self.lv,
		viplv = self.viplv,
		roletype = self.roletype,
	}
	return resume
end

function cplayer:unpackresume(resume)
	self.gold = resume.gold
	self.chip = resume.chip
	self.account = resume.account
	self.name = resume.name
	self.lv = resume.lv
	self.viplv = resume.viplv
	self.roletype = resume.roletype
end

		
function cplayer:savetodatabase()
	assert(self.pid)
	if self.nosavetodatabase then
		return
	end

	local db = dbmgr.getdb(cserver.getsrvname(self.pid))
	if self.loadstate == "loaded" then
		local data = self:save()
		db:set(db:key("role",self.pid,"data"),data)
	end
	for k,v in pairs(self.autosaveobj) do
		if v.loadstate == "loaded" then
			db:set(db:key("role",self.pid,k),v:save())
		end
	end
	-- 离线对象已超过过期时间则删除
	if self.__state == "offline" and (not self.__activetime or os.time() - self.__activetime > 300) then
		playermgr.unloadofflineplayer(self.pid)
	end
end

function cplayer:loadfromdatabase(loadall)
	if loadall == nil then
		loadall = true
	end
	assert(self.pid)
	if not self.loadstate or self.loadstate == "unload" then
		self.loadstate = "loading"
		local db = dbmgr.getdb(cserver.getsrvname(self.pid))
		local data = db:get(db:key("role",self.pid,"data"))
		pprintf("role:data=>%s",data)
		-- 正常角色至少会有基本数据
		if not data or not next(data) then
			self.loadstate = "loadnull"
		else
			self:load(data)
			self.loadstate = "loaded"
		end
	end
	if loadall then
		for k,v in pairs(self.autosaveobj) do
			if not v.loadstate or v.loadstate == "unload" then
				v.loadstate = "loading"
				local db = dbmgr.getdb(cserver.getsrvname(self.pid))
				local data = db:get(db:key("role",self.pid,k))
				v:load(data)
				v.loadstate = "loaded"
			end
		end
	end
end

function cplayer:isloaded()
	if self.loadstate == "loaded" then
		for k,v in pairs(self.autosaveobj) do
			if v.loadstate ~= "loaded" then
				return false
			end
		end
		return true
	end
	return false
end

function cplayer:create(conf)
	local name = assert(conf.name)
	local roletype =assert(conf.roletype)
	local account = assert(conf.account)
	logger.log("info","createrole",string.format("createrole,account=%s pid=%s name=%s roletype=%s ip=%s:%s",account,self.pid,name,roletype,conf.__ip,conf.__port))

	self.loadstate = "loaded"
	self.account = account
	self.name = name
	self.roletype = roletype
	self.gold = conf.gold or 0
	self.lv = conf.lv or 25
	self.chip = conf.chip or 0
	self.viplv = conf.viplv or 0
	-- scene
	self.sceneid = BORN_SCENEID
	self.pos = randlist(ALL_BORN_LOCS)
	self.warstate = NOWAR
	self.police = POLICE_SEE_ALL
	self.seen = DEFAULT_SEEN
	self.createtime = getsecond()
	local db = dbmgr.getdb()
    db:hset(db:key("role","list"),self.pid,1)
    route.addroute(self.pid)
	self:oncreate()
end

function cplayer:entergame()
	self:onlogin()
	--xpcall(self.onlogin,onerror,self)
end


-- 正常退出游戏
function cplayer:exitgame()
	xpcall(self.onlogoff,onerror,self)
	self:savetodatabase()
end


-- 客户端主动掉线处理
function cplayer:disconnect(reason)
	self:exitgame()
	self:ondisconnect(reason)
end


-- 跨服前处理流程
function cplayer:ongosrv(srvname)
end

-- 回到原服前处理流程
function cplayer:ongohome()
end


function cplayer:synctoac()
	local role = {
		roleid = self.pid,
		name = self.name,
		gold = self.gold,
		lv = self.lv,
		roletype = self.roletype,
	}
	role = cjson.encode(role)
	local url = string.format("/sync?gameflag=%s&srvname=%s&acct=%s&roleid=%s",cserver.gameflag,cserver.srvname,self.account,self.pid)
	httpc.get(cserver.accountcenter.host,url,nil,nil,role)
end


local function heartbeat(pid)
	local player = playermgr.getplayer(pid)
	if player then
		local interval = 120
		timer.timeout("player.heartbeat",interval,functor(heartbeat,pid))
		sendpackage(pid,"player","heartbeat")
	end
end

function cplayer:oncreate()
	logger.log("info","register",string.format("register,account=%s pid=%d name=%s roletype=%d lv=%s gold=%d ip=%s",self.account,self.pid,self.name,self.roletype,self.lv,self.gold,self:ip()))
	for k,obj in pairs(self.autosaveobj) do
		if obj.oncreate then
			obj:oncreate(self)
		end
	end
end

function cplayer:comptible_process()
	if not self.warstate then
		self.warstate = NOWAR
	end
	if not self.police then
		self.police = POLICE_SEE_ALL
	end
	if not self.seen then
		self.seen = DEFAULT_SEEN
	end

end

function cplayer:onlogin()
	logger.log("info","login",string.format("login,account=%s pid=%s name=%s roletype=%s lv=%s gold=%s ip=%s:%s agent=%s",self.account,self.pid,self.name,self.roletype,self.lv,self.gold,self:ip(),self:port(),skynet.address(self.__agent)))
	self:comptible_process()
	local server = globalmgr.server
	heartbeat(self.pid)
	sendpackage(self.pid,"player","resource",{
		gold = self.gold,
	})
	sendpackage(self.pid,"player","switch",self:query("switch",{
		gm = self:authority() > 0,
		friend = server:isopen("friend"),
	}))
	mailmgr.onlogin(self)
	for k,obj in pairs(self.autosaveobj) do
		if obj.onlogin then
			obj:onlogin(self)
		end
	end
	self:doing("login")
	if not self.sceneid then
		self.sceneid = BORN_SCENEID
		self.pos = randlist(ALL_BORN_LOCS)
	end
	self:enterscene(self.sceneid,self.pos,true)
	self:synctoac()
end

function cplayer:onlogoff()
	logger.log("info","login",string.format("logoff,account=%s pid=%s name=%s roletype=%s lv=%s gold=%s ip=%s:%s agent=%s",self.account,self.pid,self.name,self.roletype,self.lv,self.gold,self:ip(),self:port(),skynet.address(self.__agent)))
	mailmgr.onlogoff(self)
	for k,obj in pairs(self.autosaveobj) do
		if obj.onlogoff then
			obj:onlogoff(self)
		end
	end
	self:doing("logoff")
	self:exitscene(self.sceneid)
	self:synctoac()
end

function cplayer:ondisconnect(reason)

	logger.log("info","login",string.format("disconnect,account=%s pid=%s name=%s roletype=%s lv=%s gold=%s ip=%s:%s reason=%s",self.account,self.pid,self.name,self.roletype,self.lv,self.gold,self:ip(),self:port(),reason))
	loginqueue.pop()
end

function cplayer:ondayupdate()
end

function cplayer:onweekupdate()
end

function cplayer:onweek2update()
end

function cplayer:validpay(typ,num,notify)
	local hasnum
	if typ == "gold" then
		hasnum = self.gold
	elseif typ == "chip" then
		hasnum = self.chip
	else
		error("invalid resource type:" .. tostring(typ))
	end
	if hasnum < num then
		if notify then
			local RESNAME = {
				gold = "金币",
				chip = "chip",
			}
			net.msg.notify(self.pid,string.format("%s不足%d",resname[typ],num))
		end
		return false
	end
	return true
end

function cplayer:setlv(val,reason)
	local oldval = self.lv
	logger.log("info","lv",string.format("setlv,pid=%d lv=%d->%d reason=%s",self.pid,oldval,val,reason))
	self.lv = val
end

function cplayer:addlv(val,reason)
	local oldval = self.lv
	local newval = oldval + val
	logger.log("info","lv",string.format("addlv,pid=%d lv=%d+%d=%d reason=%s",self.pid,oldval,val,newval,reason))
	self.resume:set("lv",newval)
end

function cplayer:addgold(val,reason)
	val = math.floor(val)
	local oldval = self.gold
	local newval = oldval + val
	logger.log("info","resource/gold",string.format("addgold,pid=%d gold=%d+%d=%d reason=%s",self.pid,oldval,val,newval,reason))
	assert(newval >= 0,string.format("not enough gold:%d+%d=%d",oldval,val,newval))
	self.gold = newval
	local addgold = newval - oldval
	if addgold > 0 then
		event.playerdo(self.pid,"金币增加",addgold)
	end
	return addgold
end

function cplayer:addchip(val,reason)
	val = math.floor(val)
	local oldval = self.chip
	local newval = oldval + val
	logger.log("info","resource/chip",string.format("addchip,pid=%d chip=%d+%d=%d reason=%s",self.pid,oldval,val,newval,reason))
	assert(newval >= 0,string.format("not enough chip:%d+%d=%d",oldval,val,newval))
	self.chip = newval
	return val
end


function cplayer:additem(itemid,num,reason)
	local typename = typenameof(itemid)
	if typename == "cardbag" then
		self.cardbaglib:addcardbag(itemid,num,reason)
	elseif typename == "card" then
		self.cardlib:addcardbysid(itemid,num,reason)
	end
end

function cplayer:additems(items,reason)
	for i,item in ipairs(items) do
		self:additem(item.itemid,item.num,reason)
	end
end

function cplayer:additem2(itemdata,reason,btip)
	-- TODO:
	return itemdata.num
end

function cplayer:addres(typ,num,reason,btip)
	if typ == RESTYPE_GOLD then
		num = self:addgold(num,reason)
	elseif typ == RESTYPE_CHIP then
		num = self:addchip(num,reason)
	else
		error("Invlid restype:" .. tostring(typ))
	end
	if btip then
		local msg = string.format("%s #<type=%s># X%d",num > 0 and "获取" or "花费",typ,num)
		net.msg.notify(self.pid,msg)
	end
	return num
end

function cplayer:doing(what)
	if globalmgr.server:isopen("friend") then
		local frdblk = self.frienddb:getfrdblk(self.pid)
		frdblk:set("doing",what)
	end
end

function cplayer:pack_fight_profile(wartype)
	local mode = WarType[wartype]
	local cardtableid = assert(self:query("fight.cardtableid"))
	local cardtable = self.cardtablelib:getcardtable(cardtableid)
	
	return {
		pid = self.pid,
		lv = self.lv,
		name = self.name,
		wincnt = self:query("fight.wincnt",0),
		failcnt = self:query("fight.failcnt",0),
		consecutive_wincnt = self:query("fight.consecutive_wincnt",0),
		consecutive_failcnt = self:query("fight.consecutive_failcnt",0),
		show_achivelist = self:query("fight.show_achivelist",{}),
		race = cardtable.race,
		cardtable = cardtable,
	}
end

function cplayer:unpack_fight_profile(profile)
	local wincnt = assert(profile.wincnt)	
	local failcnt = assert(profile.failcnt)
	local consecutive_wincnt = assert(profile.consecutive_wincnt)
	local consecutive_failcnt = assert(profile.consecutive_failcnt)
	self:set("fight.wincnt",wincnt)
	self:set("fight.failcnt",failcnt)
	self:set("fight.consecutive_wincnt",consecutive_wincnt)
	self:set("fight.consecutive_failcnt",consecutive_failcnt)
	-- check task
	-- check achievement
end

-- getter
function cplayer:authority()
	if skynet.getenv("mode") == "debug" then
		return 100
	end
	return self:query("auth",0)
end

function cplayer:ip()
	return self.__ip
end

function cplayer:port()
	return self.__port
end

function cplayer:teamstate()
	local teamid = self.teamid
	if not teamid then
		return NO_TEAM
	end
	local team = teammgr.getteam(teamid)
	if not team then
		self.teamid = nil
		return NO_TEAM 
	end
	return team:teamstate(player.pid)
end

function cplayer:getteamid()
	if self.teamid then
		local team = teammgr:getteam(self.teamid)
		if not team then
			logger.log("error","team",string.format("getteamid [no team],pid=%d teamid=%d",self.pid,self.teamid))
			sendpackage(self.pid,"team","delmember",{
				teamid = self.teamid,
				pid = self.pid,
			})
			self.teamid = nil
		elseif not team:ismember(self.pid) then
			logger.log("error","team",string.format("getteamid [not a member],pid=%d teamid=%d",self.pid,self.teamid))
			sendpackage(self.pid,"team","delmember",{
				teamid = self.teamid,
				pid = self.pid,
			})
			self.teamid = nil
		end
	end
	return self.teamid
end

-- 组对成员
function cplayer:packmember()
	return {
		pid = self.pid,
		name = self.name,
		lv = self.lv,
		roletype = self.roletype,
		state = self:teamstate(),
	}
end

-- 场景信息
function cplayer:packscene()
	return {
		pid = self.pid,
		name = self.name,
		lv = self.lv,
		roletype = self.roletype,
		teamid = self:getteamid() or 0,
		state = self:teamstate(),	
		warstate = self.warstate,
		pos = self.pos,
		seen = self.seen,
		police = self.police,
		agent = self.__agent,
	}
end

-- setter
function cplayer:setauthority(auth)
	self:set("auth",auth)
end

function cplayer:move(package)
	local pid = self.pid
	local scene = scenemgr.getscene(self.sceneid)
	if scene then
		if package.srcpos then
			self:setpos(package.srcpos)
		end
		skynet.send(scene.scenesrv,"lua","move",pid,package)	
	end
end

function cplayer:stop()
	local pid = self.pid
	local scene = scenemgr.getscene(self.sceneid)
	if scene then
		skynet.send(scene.scenesrv,"lua","stop",pid)	
	end
end

function cplayer:setpos(pos,nosnyc)
	local pid = self.pid
	local scene = scenemgr.getscene(self.sceneid)
	if scene then
		self.pos = deepcopy(pos)
		if not nosync then
			skynet.send(scene.scenesrv,"lua","setpos",pid,pos)
		end
	end
end

function cplayer:exitscene(sceneid)
	sceneid = sceneid or self.sceneid
	if sceneid then
		local scene = scenemgr.getscene(sceneid)
		if scene then
			skynet.send(scene.scenesrv,"lua","exit",self.pid)
		end
	end
end

function cplayer:enterscene(sceneid,pos,noexit)
	assert(sceneid)
	assert(pos)
	local pid = self.pid
	local newscene = scenemgr.getscene(sceneid)
	if not newscene then
		return
	end
	if not noexit then
		self:exitscene(self.sceneid)
	end
	skynet.send(newscene.scenesrv,"lua","enter",self:packscene())
	self.sceneid = sceneid
	self:setpos(pos)
end

return cplayer
