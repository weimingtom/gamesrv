srvlist = {
	gamesrv_100 = {
		ip = "127.0.0.1",
		port = 8080,
		minroleid = 10000,
		maxroleid = 1000000,
		maxclient = 10240,
		db = 0,
	},
	gamesrv_101 = {
		ip = "127.0.0.1",
		port = 8089,
		minroleid = 1000000,
		maxroleid = 2000000,
		maxclient = 10240,
		db = 11,
	},
	frdsrv = {
		ip = "127.0.0.1",
		port = 9000,
		db = 1,
	},
	warsrv_1000 = {
		ip = "127.0.0.1",
		port = 10000,
		db = 2,
	},
	warsrvmgr = {
		ip = "127.0.0.1",
		port = 11000,
	}
}

return srvlist

