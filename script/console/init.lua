console = {}

local function console_main_loop()
	local stdin = socket.stdin()
	if not stdin then -- startserver in deamon
		return
	end
	socket.lock(stdin)
	while true do
		local cmdline = socket.readline(stdin, "\n")
		if cmdline ~= "" then
			local func,err = load(cmdline)
			if not func then
				skynet.error("error",err)
			else
				func = functor(xpcall,func,onerror)
				-- 防止控制台被阻塞住
				skynet.timeout(0,func)
			end
		end
	end
	--socket.unlock(stdin)
end

function console.init()
	skynet.fork(console_main_loop)
end
return console
