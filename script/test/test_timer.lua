

local function local_timer(num)
	print("local_timer",os.time(),num,local_timer)
	timer.timeout("timer.local_timer",10,functor(local_timer,num+1))
end

function __global_timer(num)
	print("__global_timer",os.time(),num,__global_timer)
	timer.timeout("timer.__global_timer",10,functor(__global_timer,num+1))
end

function test_timer(...)
	local args = table.pack(...)
	name = ...
	print("test_timer",...)
	timer.timeout(name,5,function ()
		test_timer(table.unpack(args))
	end)
end

local function test()
	--local_timer(1)
	--__global_timer(1)
	timer.timeout("timer.test_timer",5,function ()
		test_timer("timer.test_timer",1)
	end)
	timer.timeout("timer.test_timer",5,function ()
		test_timer("timer.test_timer",2)
	end)
	local id = timer.timeout("timer.test_timer",5,function ()
		test_timer("timer.test_timer",3)
	end)
	timer.timeout("timer.test_timer",3,function ()
		timer.deltimer("timer.test_timer",id)
	end)
	timer.timeout("timer.deltimer",30,function ()
		timer.untimeout("timer.test_timer")
	end)
end

return test
