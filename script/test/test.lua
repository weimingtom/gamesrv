local function test()
	local unexist_srv = 23421
	print("before send")
	skynet.send(unexist_srv,"lua","send_request","login","kick","test")
	print("after send")
	print("before call")
	skynet.call(unexist_srv,"lua","send_request","login","kick","test")
	print("after call")
end

return test
