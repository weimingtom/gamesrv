require "script.logger"

local function test()
	logger.init()
	logger.debug("test/tmp1","hello,world")
	logger.info("test/tmp1","ok")
	logger.warning("test/tmp1","lua")
	logger.error("test/tmp1","oops")
	logger.critical("test/tmp1","what")
	logger.setmode(logger.LOG_INFO)
	logger.debug("test/tmp1","hello,world")
	logger.info("test/tmp1","ok")
	logger.warning("test/tmp1","lua")
	logger.error("test/tmp1","oops")
	logger.critical("test/tmp1","what")
	logger.shutdown()
	logger.debug("test/tmp1","hello,world")
	logger.debug("test/tmp2","hello,world")
	logger.debug("tmp","ok")
end

return test
