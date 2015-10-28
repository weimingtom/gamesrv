-- [700,800)
local proto = {}
proto.c2s = [[

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
		attach 3 : *ResOrItemType
	}
}

mail_delallmail 705 {
}

]]

proto.s2c = [[

mail_syncmail 700 {
	request {
		mail 0 : MailType
	}
}
]]

return proto
