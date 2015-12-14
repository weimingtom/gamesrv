local function test(n)
	n = n or 0
	if n > 10 then
		return
	end
	timer.timeout("timer.test",5,functor(test,n+1))
	print(">>>",n)
	local ret = cluster.call("gamesrv_101","rpc","error","test")
	print("after call")
end

return test
