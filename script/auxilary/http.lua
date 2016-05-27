function packbody(errcode,result)
	return cjson.encode({
		errcode = errcode,
		result = result,
	})
end

function unpackbody(body)
	local data = cjson.decode(body)
	return tonumber(data.errcode),data.result
end

function response(id,statuscode,bodyfunc,header)
	local ok,err = httpd.write_response(sockethelper.writefunc(id),statuscode,bodyfunc,header)
	if not ok then
		skynet.error(string.format("fd = %d,%s",id,err))
	end
end

