
logger = logger or {}
LOGGERSRV=".LOGGER"
--function logger.write(filename,msg)
--	skynet.send(LOGGERSRV,"lua","write",filename,msg)
--end

function logger.debug(filename,...)
	skynet.send(LOGGERSRV,"lua","debug",filename,...)
end

function logger.info(filename,...)
	skynet.send(LOGGERSRV,"lua","info",filename,...)
end

function logger.warning(filename,...)
	skynet.send(LOGGERSRV,"lua","warning",filename,...)
end

function logger.error(filename,...)
	skynet.send(LOGGERSRV,"lua","error",filename,...)
end

function logger.critical(filename,...)
	skynet.send(LOGGERSRV,"lua","critical",filename,...)
end

function logger.log(mode,filename,...)
	skynet.send(LOGGERSRV,"lua","log",mode,filename,...)
end

function logger.sendmail(to_list,subject,content)
	skynet.send(LOGGERSRV,"lua","sendmail",to_list,subject,content)
end

-- console/print
function logger.print(...)
	--print(string.format("[%s]",os.date("%Y-%m-%d %H:%M:%S")),...)
	skynet.send(LOGGERSRV,"lua","print",...)
end

function logger.pprintf(fmt,...)
	--pprintf(string.format("[%s] %s",os.date("%Y-%m-%d %H:%M:%S"),fmt),...)
	skynet.send(LOGGERSRV,"lua","pprintf",fmt,...)
end


function logger.setmode(mode)
	skynet.send(LOGGERSRV,"lua","setmode",mode)
end


function logger.init()
	LOGGERSRV = skynet.newservice("script/service/loggerd")
	skynet.name(".LOGGER",LOGGERSRV)
	return skynet.call(LOGGERSRV,"lua","init")
end

function logger.shutdown()
	skynet.send(LOGGERSRV,"lua","shutdown")
end
return logger
