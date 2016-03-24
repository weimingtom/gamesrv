skynet = require "script.skynet"
require "script.base.functions"

logger = logger or {}
function logger.write(filename,msg)
	assert(string.match(filename,"^[a-z_]+[a-z_0-9/]*$"),"invalid log filename:" .. tostring(filename))
	local now = os.time()
	local date = os.date("%Y-%m-%d %H:%M:%S",now)
	if logger.time.sec ~= now then
		logger.time.sec = now
		logger.time.usec = 0
	end
	logger.time.usec = logger.time.usec + 1
	fd = logger.gethandle(filename)
	msg = string.format("[%s %06d] %s",date,logger.time.usec,msg)
	fd:write(msg)
	fd:flush()
	return msg
end

function logger.debug(filename,...)
	if logger.mode > logger.LOG_DEBUG then
		return
	end
	logger.write(filename,string.format("[%s] %s\n","DEBUG",table.concat({...},"\t")))
end

function logger.info(filename,...)
	if logger.mode > logger.LOG_INFO then
		return
	end
	logger.write(filename,string.format("[%s] %s\n","INFO",table.concat({...},"\t")))
end

function logger.warning(filename,...)
	if logger.mode > logger.LOG_WARNING then
		return
	end
	logger.write(filename,string.format("[%s] %s\n","WARNING",table.concat({...},"\t")))
end

function logger.error(filename,...)
	if logger.mode > logger.LOG_ERROR then
		return
	end
	logger.write(filename,string.format("[%s] %s\n","ERROR",table.concat({...},"\t")))
end

function logger.critical(filename,...)
	if logger.mode > logger.LOG_CRITICAL then
		return
	end
	local msg = string.format("[%s] %s\n","CRITICAL",table.concat({...},"\t"))
	msg = logger.write(filename,msg)
	skynet.error(msg)
	logger.sendmail("2457358113@qq.com","CRITICAL",msg)
end

function logger.log(mode,filename,...)
	local log = assert(logger[mode],"invalid mode:" .. tostring(mode))
	assert(select("#",...) > 0,string.format("%s %s:null logname",mode,filename))
	log(filename,...)
end

function logger.sendmail(to_list,subject,content)
	function escape(str) 
		local ret = string.gsub(str,"\"","\\\"")
		return ret
	end
	strsh = string.format("cd ../shell && python sendmail.py %s \"%s\" \"%s\"",to_list,escape(subject),escape(content))
	os.execute(strsh)
end

-- console/print
function logger.print(...)
	if logger.mode > logger.LOG_DEBUG then
		return
	end
	
	print(string.format("[%s]",os.date("%Y-%m-%d %H:%M:%S")),...)
end

function logger.pprintf(fmt,...)
	if logger.mode > logger.LOG_DEBUG then
		return
	end
	
	pprintf(string.format("[%s] %s",os.date("%Y-%m-%d %H:%M:%S"),fmt),...)
end

function logger.gethandle(name)
	if not logger.handles[name] then
		local filename = string.format("%s/%s.log",logger.path,name)
		local parent_path = string.match(name,"(.*)/.*")
		if parent_path then
			os.execute("mkdir -p " .. logger.path .. "/" .. parent_path)
		end
		local fd  = io.open(filename,"a+b")
		assert(fd,"logfile open failed:" .. tostring(filename))
		fd:setvbuf("line")
		logger.handles[name] = fd
	end
	return logger.handles[name]
end

function logger.setmode(mode)
	assert(type(mode) == "number","invalid logger mode:" .. tostring(mode))
	logger.mode = mode
end

logger.LOG_DEBUG = 1
logger.LOG_INFO = 2
logger.LOG_WARNING = 3
logger.LOG_ERROR = 4
logger.LOG_CRITICAL = 5
logger.MODE_NAME_ID = {
	debug = logger.LOG_DEBUG,
	info = logger.LOG_INFO,
	warning = logger.LOG_WARNING,
	["error"] = logger.LOG_ERROR,
	critical = logger.LOG_CRITICAL,
}

function logger.init()
	print("logger init")
	local modename = skynet.getenv("mode")
	logger.mode = assert(logger.MODE_NAME_ID[modename],"Invalid modename:" .. tostring(modename))
	logger.handles = {}
	logger.time = {
		sec = 0,
		usec = 0,
	}
	logger.path = skynet.getenv("workdir") .. "/log"
	print("logger.path:",logger.path)
	os.execute(string.format("mkdir -p %s",logger.path))
	os.execute(string.format("ls -R %s > .log.tmp",logger.path))
	fd = io.open(".log.tmp","r")
	local filename
	local name
	local section = ""
	for line in fd:lines() do
		if line:sub(#line) == ":" then
			if line == logger.path .. ":" then
				section = ""
			else
				section = string.match(line,string.format("%s/([^:]*):",logger.path))
			end
		else
			if line:sub(#line-3) == ".log" then
				if section ~= "" then
					name = section .. "/" .. line:sub(1,#line-4)
				else
					name = line:sub(1,#line-4)
				end
				filename = string.format("%s/%s.log",logger.path,name)
				--print(filename)
				local fd  = io.open(filename,"a+b")
				assert(fd,"logfile open failed:" .. tostring(filename))
				fd:setvbuf("line")
				logger.handles[name] = fd
			end
		end
	end
	fd:close()
	os.execute("rm -rf .log.tmp")
	skynet.retpack(true)
end

function logger.shutdown()
	print("logger shutdown")
	for name,fd in pairs(logger.handles) do
		fd:close()
	end
	logger.handles = {}
	skynet.exit()
end

skynet.start(function ()
	skynet.dispatch("lua",function (session,source,cmd,...)
		local func = logger[cmd]
		if not func then
			logger.log("warning","error",string.format("[logger] invalid cmd:%s",cmd))
		end
		func(...)
	end)
end)

return logger
