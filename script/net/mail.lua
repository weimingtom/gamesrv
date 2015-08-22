
require "script.mail"
require "script.mail.mailmgr"

netmail = netmail or {}

-- c2s
local REQUEST = {} 
netmail.REQUEST = REQUEST

function REQUEST.openmailbox(player)
	local pid = player.pid
	local mailbox = mailmgr.getmailbox(pid)
	local mails = mailbox:getmails()
	local packdata = {}
	for _,mail in ipairs(mails) do
		table.insert(packdata,mail:pack())
	end
	return {mails = packdata,}
end

function REQUEST.readmail(player,request)
	local pid = player.pid
	local mailid = assert(request.mailid)
	local mailbox = mailmgr.getmailbox(pid)
	local mail = mailbox:getmail(mailid)
	if not mail then
		return
	end
	mail.readtime = os.time()
	netmail.syncmail(pid,{
		mailid = mail.mailid,
		readtime = mail.readtime,
	})
end

function REQUEST.delmail(player,request)
	local pid = player.pid
	local mailid = assert(request.mailid)
	local mailbox = mailmgr.getmailbox(pid)
	local mail = mailbox:delmail(mailid)
	return {result = mail and true or false,}		
end

function REQUEST.getattach(player,request)
	local pid = player.pid
	local mailid = assert(request.mailid)
	local mailbox = mailmgr.getmailbox(pid)
	mailbox:getattach(mailid)
end

function REQUEST.sendmail(player,request)
	local pid = player.pid
	local targetid = assert(request.pid)
	local title = request.title or ""
	local content = assert(request.content)
	local attach = request.attach or {}
	if pid == targetid then
		return
	end
	if not route.getsrvname(targetid) then
		net.msg.notify(pid,string.format("找不到id为%d的玩家",targetid))
		return
	end
	mailmgr.sendmail(targetid,{
		srcid = pid,
		author = player:query("name"),
		title = title,
		content = content,
		attach = attach,
	})

end

function REQUEST.delallmail(player,request)
	local pid = player.pid
	local mailbox = mailmgr.getmailbox(pid)
	mailbox:delallmail()
end

local RESPONSE = {}
netmail.RESPONSE = RESPONSE

-- s2c
function netmail.syncmail(pid,maildata)
	sendpackage(pid,"mail","syncmail",maildata)
end

return netmail
