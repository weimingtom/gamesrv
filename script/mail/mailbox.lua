
require "script.db"
require "script.attrblock.saveobj"
require "script.logger"
require "script.playermgr"

local MIN_MAILID = 1000
local MAX_MAILID = MAX_NUMBER

cmailbox = class("cmailbox",csaveobj)

function cmailbox:init(pid)
	self.flag = "cmailbox"
	csaveobj.init(self,{
		pid = pid,
		flag = self.flag,
	})
	self.pid = pid
	self.loadstate = "unload"
	self.mailid = MIN_MAILID
	self.mails = {}
	self.maillist = {}
	self:autosave()
end

function cmailbox:load(data)
	require "script.mail"
	if not data or not next(data) then
		return
	end
	self.mailid = data.mailid
	for mailid,maildata in pairs(data.mails) do
		mailid = tonumber(mailid)
		local mail = cmail.new({
			mailid = mailid,
		})
		mail:load(maildata)
		self:__addmail(mail)
	end
end

function cmailbox:save()
	local data = {}
	data.mailid = self.mailid
	local mails = {}
	for mailid,mail in pairs(self.mails) do
		mails[tostring(mailid)] = mail:save()
	end
	data.mails = mails
	return data
end

function cmailbox:clear()
end

function cmailbox:genid()
	if self.mailid >= MAX_MAILID then
		self.mailid = MIN_MAILID
	end
	self.mailid = self.mailid + 1
	return self.mailid
end

function cmailbox:__addmail(mail)
	local mailid = mail.mailid
	assert(self.mails[mailid] == nil)
	self.mails[mailid] = mail
	table.insert(self.maillist,mail)
	return mail
end

-- wrapper
function cmailbox:addmail(mail)
	logger.log("info","mail",format("addmail,pid=%d srcid=%d mailid=%d data=%s",self.pid,mail.srcid,mail.mailid,mail:pack()))
	local ret = self:__addmail(mail)
	return ret
end

function cmailbox:delmail(mailid)
	local mail = self.mails[mailid]
	if mail then
		logger.log("info","mail",format("delmail,pid=%d,srcid=%d mailid=%d",self.pid,mail.srcid,mailid))
		self.mails[mailid] = nil
		for pos,v in ipairs(self.maillist) do
			if v.mailid == mailid then
				table.remove(self.maillist,pos)
				break
			end
		end
	end
end

function cmailbox:delallmail()
	for i = #self.maillist,1,-1 do
		local mailid = self.maillist[i].mailid
		self:delmail(mailid)
	end
end

function cmailbox:getattach(mailid)
	local pid = self.pid
	local player = playermgr.getplayer(pid)
	if not player then
		return
	end
	local mail = self:getmail(mailid)
	if not mail then
		return
	end
	assert(mail.pid == pid)
	logger.log("info","mail",format("getattach,pid=%d srcid=%d mailid=%d attach=%s",pid,mail.srcid,mailid,mail.attach))
	if next(mail.attach) then
		local attach = mail.attach
		mail.attach = {}
		local reason = "getattach"
		if attach.gold > 0 then
			player:addgold(attach.gold,reason)
		end
		if attach.chip > 0 then
			player:addchip(attach.chip,reason)
		end
		if #attach.items > 0 then
			player:additems(attach.items,reason)
		end
		netmail.syncmail(pid,{
			mailid = mail.mailid,
			attach = mail.attach,
		})
	end
end

function cmailbox:getmail(mailid)
	return self.mails[mailid]
end

function cmailbox:getmails()
	return self.maillist
end

function cmailbox:length()
	return #self.maillist
end

function cmailbox:loadfromdatabase()
	if self.loadstate == "unload" then
		self.loadstate = "loading"
		local data = db:get(db:key("mail",self.pid))
		self:load(data)
		self.loadstate = "loaded"
	end
end

function cmailbox:savetodatabase()
	if self.nosavetodatabase then
		return
	end
	if self.loadstate == "loaded" then
		local data = self:save()
		db:set(db:key("mail",self.pid),data)
	end
end

return cmailbox
