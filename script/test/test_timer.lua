

local function local_timer(num)
	print("local_timer",os.time(),num,local_timer)
	timer.timeout("timer.local_timer",10,functor(local_timer,num+1))
end

function __global_timer(num)
	print("__global_timer",os.time(),num,__global_timer)
	timer.timeout("timer.__global_timer",10,functor(__global_timer,num+1))
end

local function test()
	local_timer(1)
	__global_timer(1)
end

return test
