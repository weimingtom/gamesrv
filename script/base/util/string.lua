-- 扩展string
function string.rtrim(str)
	return string.gsub(str,"^[ \t\n\r]+","")
end

function string.ltrim(str)
	return string.gsub(str,"[ \t\n\r]+$","")
end

function string.trim(str)
	str = string.ltrim(str)
	return string.rtrim(str)
end

function string.isdigit(str)
	local ret = pcall(tonumber,str)
	return ret
end

function string.hexstr(str)
	assert(type(str) == "string")
	local len = #str
	return string.format("0x" .. string.rep("%x",len),string.byte(str,1,len))
end

local NON_WHITECHARS_PAT = "%S+"
function string.split(str,pat,maxsplit)
	pat = pat and string.format("[^%s]+",pat) or NON_WHITECHARS_PAT
	maxsplit = maxsplit or -1
	local ret = {}
	local i = 0
	for s in string.gmatch(str,pat) do
		if not (maxsplit == -1 or i <= maxsplit) then
			break
		end
		table.insert(ret,s)
		i = i + 1
	end
	return ret
end

function string.urlencodechar(char)
	return string.format("%%%02X",string.byte(char))
end

function string.urldecodechar(hexchar)
	return string.char(tonumber(hexchar,16))
end

function string.urlencode(str)
	str = string.gsub(str,"([^%w%.%- ])",string.urlencodechar)
	str = string.gsub(str," ","+")
	return str
end

function string.urldecode(str)
	str = string.gsub(str,"+"," ")
	str = string.gsub(str,"%%(%x%x)",string.urldecodechar)
	return str
end

