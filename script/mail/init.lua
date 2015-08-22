

cmail = class("cmail")

function cmail:init(conf)
	conf = conf or {}
	self.mailid = conf.mailid or 0
	self.pid = conf.pid or 0
	self.sendtime = conf.sendtime or 0
	self.author = conf.author or ""
	self.title = conf.title or ""
	self.content = conf.content or ""
	self.attach = conf.attach or {}
	self.readtime = conf.readtime or 0
	self.srcid = conf.srcid or 0
end

function cmail:load(data)
	if not data or not next(data) then
		return
	end
	self.mailid = data.mailid
	self.pid = data.pid
	self.sendtime = data.sendtime
	self.author = data.author
	self.title = data.title
	self.content = data.content
	self.attach = data.attach
	self.readtime = data.readtime
	self.srcid = data.srcid
end

function cmail:save()
	local data = {}
	data.mailid = self.mailid
	data.pid = self.pid
	data.sendtime = self.sendtime
	data.author = self.author
	data.title = self.title
	data.content = self.content
	data.attach = self.attach
	data.readtime = self.readtime
	data.srcid = self.srcid
	return data
end

function cmail:pack()
	return self:save()
end

return cmail
