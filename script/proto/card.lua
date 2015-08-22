-- [400,500)
local proto = {}
proto.c2s = [[
card_updatecardtable 400 {
	request {
		id 0 : integer
		race 1: integer
		# card sid array
		cards 2 : *integer
		# 0--normal; 1--nolimit
		mode 3 : integer 
	}
	response {
		# 0--Ok; other--not enough card sid
		result 0 : integer
	}
}

card_delcardtable 401 {
	request {
		id 0 : integer
		mode 1: integer
	}
}

card_compose 402 {
	request {
		cardid 0 : integer
	}
}

card_decompose 403 {
	request {
		cardid 0 : integer
	}
}

card_decomposeleft 404 {
}
]]

proto.s2c = [[
card_addcard 400 {
	request {
		cardid 0 : integer
		sid 1 : integer
	}
}

card_delcard 401 {
	request {
		cardid 0 : integer
	}
}
]]

return proto
