srvlist = {
	accountcenter = {
		ip = "127.0.0.1",
		port = 7000,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 10,
		},
	},
	gamesrv_100 = {
		ip = "127.0.0.1",
		port = 8001,
		minroleid = 10000,
		maxroleid = 9999999,
		maxclient = 10240,
        srvno = 100,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 0,
		},
	},
	gamesrv_101 = {
		ip = "127.0.0.1",
		port = 8002,
		minroleid = 10000,
		maxroleid = 9999999,
		maxclient = 10240,
        srvno = 101,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 11,
		},
	},
	resumesrv = {
		ip = "127.0.0.1",
		port = 9000,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 1,
		},
	},
	warsrv_1000 = {
		ip = "127.0.0.1",
		port = 10000,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 2,
		},
	},
	warsrvmgr = {
		ip = "127.0.0.1",
		port = 11000,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 3,
		},
	}
}

return srvlist

