
require "script.playermgr"
require "script.mail.mailmgr"
require "script.net.mail"

local function test(pid1,pid2)
	local player1 = playermgr.getplayer(pid1)
	local player2 = playermgr.getplayer(pid2)
	print(pid1,pid2,player1,player2)
	if not (player1 and player2) then
		print("not online")
		return
	end
	player1.carddb:clear()
	player2.carddb:clear()
	local mailbox1 = mailmgr.getmailbox(pid1)
	local mailbox2 = mailmgr.getmailbox(pid2)
	mailbox1:delallmail()
	mailbox2:delallmail()
	local mailrequest = net.mail.REQUEST
	local allmail = mailrequest.openmailbox(player1)
	allmail = allmail.mails
	assert(#allmail == 0)
	-- cann't send to youself
	mailrequest.sendmail(player1,{
		pid = pid1,
		title = "",
		content = "",
	})
	local mails = mailbox1:getmails()
	assert(#mails == 0)
	mails = mailbox2:getmails()
	assert(#mails == 0)
	mailrequest.sendmail(player1,{
		pid = pid2,
		title = "title",
		content = "content",
	})
	mails = mailbox2:getmails()
	print("mail num",#mails)
	assert(#mails == 1)
	local mail = mails[1]
	mailrequest.delmail(player2,{
		mailid = mail.mailid,
	})
	mails = mailbox2:getmails()
	assert(#mails == 0)
	mailrequest.sendmail(player1,{
		pid = pid2,
		title = "title",
		content = "content",
		attach = {
			gold = 100,
			chip = 200,
			items = {
				{type=14101,num=2,},
				{type=14201,num=5},
			},
		}
	})
	mails = mailbox2:getmails()
	mail = mails[1]
	assert(mail.title == "title" and mail.content == "content")
	pprintf("mail:%s",mail:save())
	local oldgold = player2:getgold()
	local oldchip = player2:getchip()
	mailrequest.getattach(player2,{
		mailid = mail.mailid,
	})
	assert(player2:getgold() == oldgold + 100)
	assert(player2:getchip() == oldchip + 200)
	local carddb = player2:getcarddbbysid(14101)
	local amount = carddb:getamountbysid(14101)
	assert(amount == 2)
	carddb = player2:getcarddbbysid(14201)
	amount = carddb:getamountbysid(14201)
	print(14201,"amount",amount)
	assert(amount == 5)
	local num = 10
	for i = 1,num do
		local suffix = tostring(i)
		mailrequest.sendmail(player1,{
			pid = pid2,
			title = "title" .. suffix,
			content = "content" .. suffix,
		})
	end
	mails = mailbox2:getmails()
	assert(#mails == 11)
	mailrequest.delallmail(player2,{
	})
	mails = mailbox2:getmails()
	assert(#mails == 0)

end

return test
