--/*
-- 所有服务器配置信息，保证和配置文件中填写一样，自身配置优先读取配置文件
-- 获取其他服信息才读取这里的配置
--*/
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
	datacenter = {
		ip = "127.0.0.1",
		port = 9000,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 11,
		},
	},
	warsrv_1000 = {
		ip = "127.0.0.1",
		port = 10000,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 12,
		},
	},
	warsrvmgr = {
		ip = "127.0.0.1",
		port = 11000,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 13,
		},
	},
	gamesrv_100 = {
		ip = "127.0.0.1",
		port = 8001,
		minroleid = 1000000,
		maxroleid = 2000000,
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
		minroleid = 2000000,
		maxroleid = 3000000,
		maxclient = 10240,
        srvno = 101,
		db = {
			host = "127.0.0.1",
			port = 6800,
			db = 1,
		},
	},

}

return srvlist

