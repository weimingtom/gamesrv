function packbody(result,extra)
	return string.format("result=%d|%s",result,cjson.encode(extra))
end

function unpackbody(body)
	local result,extra = body:match("result=([%d]+)|(.*)")
	return tonumber(result),cjson.decode(extra)
end

function response(id,statuscode,bodyfunc,header)
	local ok,err = httpd.write_response(sockethelper.writefunc(id),statuscode,bodyfunc,header)
	if not ok then
		skynet.error(string.format("fd = %d,%s",id,err))
	end
end

