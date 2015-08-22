local skynet = require "skynet"
require "script.logger"
timer = {}
function timer.timeout(flag,ti,func)
	ti = ti * 100
	logger.log("debug","timer",string.format("timeout,flag=%s ti=%s func=%s",flag,ti,func))
	skynet.timeout(ti,func)
end

function timer.timeout2(flag,ti,func)
	logger.log("debug","timer",string.format("timeout2,flag=%s,ti=%s func=%s",flag,ti,func))
end

function timer.untimeout(flag)
	logger.log("debug","timer",string.format("untimeout,flag=%s",flag))
end
return timer
