-- [700,800)
local proto = {}
proto.c2s = [[

.ItemType {
	itemid 0 : integer
	num 1 : integer
}

.AttachType {
	gold 0 : integer
	chip 1 : integer	
	items 2 : *ItemType
}

.MailType {
	mailid 0 : integer
	pid 1 : integer
	sendtime 2 : integer
	author 3 : string
	title 4 : string
	content 5 : string
	attach 6 : AttachType
	readtime 7 : integer
	srcid 8 : integer
}

mail_openmailbox 700 {
	response {
		mails 0 : *MailType
	}
}

mail_readmail 701 {
	request {
		mailid 0 : integer
	}
}

mail_delmail 702 {
	request {
		mailid 0 : integer
	}
	response {
		result 0 : boolean
	}
}

mail_getattach 703 {
	request {
		mailid 0 : integer
	}
}

mail_sendmail 704 {
	request {
		pid 0 : integer
		title 1 : string
		content 2 : string
		attach 3 : *AttachType
	}
}

mail_delallmail 705 {
}

]]

proto.s2c = [[
.ItemType {
	itemid 0 : integer
	num 1 : integer
}

.AttachType {
	gold 0 : integer
	chip 1 : integer	
	items 2 : *ItemType
}

mail_syncmail 700 {
	request {
		mailid 0 : integer
		pid 1 : integer
		sendtime 2 : integer
		author 3 : string
		title 4 : string
		content 5 : string
		attach 6 : AttachType
		readtime 7 : integer
		srcid 8 : integer
	}
}
]]

return proto
