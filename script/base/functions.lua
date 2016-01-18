
unpack = unpack or table.unpack

STARTTIME1 = 1408896000  --2014-08-25 00:00:00 Mon Aug
STARTTIME2 = 1408809600  --2014-08-24 00:00:00 Sun Aug
HOUR_SECS = 3600
DAY_SECS = 24 * HOUR_SECS 
WEEK_SECS = 7 * DAY_SECS

SAVE_DELAY = 300

-- number
MAX_NUMBER = math.floor(2 ^ 31 - 1)
MIN_NUMBER = -MAX_NUMBER

MAX_ITEMID = 10000

SYSTEM_MAIL = 0

--用户必须保证对象非递归嵌套表
function self_tostring(obj)
	if type(obj) ~= "table" then
		return tostring(obj)
	end
	local cache = {}
	table.insert(cache,"{")
	for k,v in pairs(obj) do
		if type(k) == "number" then
			--table.insert(cache,self_tostring(v)..",")
			table.insert(cache,string.format("[%d]=%s,",k,self_tostring(v)))
		else
			local str = string.format("%s=%s,",self_tostring(k),self_tostring(v))
			table.insert(cache,str)	
		end
	end
	table.insert(cache,"}")
	return table.concat(cache)
end

function format(fmt,...)
	--local args = {...}	--无法处理nil值参数
	local args = table.pack(...)
	local len = math.max(#args,args.n or 0)
	for i = 1, len do
		if type(args[i]) == "table" then
			args[i] = self_tostring(args[i])
		elseif type(args[i]) ~= "number" then
			args[i] = tostring(args[i])
		end
	end
	return string.format(fmt,unpack(args))
end

function printf(fmt,...)
	print(format(fmt,...))
end

function pretty_tostring(obj,indent)
	indent = indent or 0
	if type(obj) ~= "table" then
		return tostring(obj)
	end
	local cache = {}
	table.insert(cache,"{")
	indent = indent + 4
	if indent >= 4 * 25 then
		local msg = "deep >= 25,may be in endless"
		skynet.error(msg)
		print(msg)
		return {"...",}
	end
	for k,v in pairs(obj) do
		if type(k) == "number" then
			table.insert(cache,string.rep(" ",indent) .. string.format("[%d]=%s,",k,pretty_tostring(v,indent)))
		else
			local str = string.rep(" ",indent) .. string.format("%s=%s,",pretty_tostring(k,indent),pretty_tostring(v,indent))
			table.insert(cache,str)	
		end
	end
	indent = indent - 4
	table.insert(cache,string.rep(" ",indent) .. "}")
	return table.concat(cache,"\n")
end

function pretty_format(fmt,...)
	--local args = {...}	--无法处理nil值参数
	local args = table.pack(...)
	local len = math.max(#args,args.n or 0)
	for i = 1, len do
		if type(args[i]) == "table" then
			args[i] = pretty_tostring(args[i],0)
		elseif type(args[i]) ~= "number" then
			args[i] = tostring(args[i])
		end
	end
	return string.format(fmt,unpack(args))
end

function pprintf(fmt,...)
	print(pretty_format(fmt,...))
end


function keys(t)
	local ret = {}
	for k,v in pairs(t) do
		table.insert(ret,k)
	end
	return ret
end

function values(t)
	local ret = {}
	for k,v in pairs(t) do
		table.insert(ret,v)
	end
	return ret
end

function remove_from(t,val,maxcnt)
	local delkey = {}
	for k,v in pairs(t) do
		if v == val then
			if not maxcnt or #delkey < maxcnt then
				delkey[#delkey] = k
			else
				break
			end
		end
	end
	for _,k in pairs(delkey) do
		t[k] = nil
	end
	return #delkey
end

function list(t)
	local ret = {}
	for k,v in pairs(t) do
		ret[#ret+1] = v
	end
	return ret
end

function range(b,e,step)
	step = step or 1
	if not e then
		e = b
		b = 1
	end
	local list = {}
	for i = b,e,step do
		table.insert(list,i)
	end
	return list
end


local function less_than(lhs,rhs)
	return lhs < rhs
end

function lower_bound(t,val,cmp)
	cmp = cmp or less_than
	local len = #t
	local first,last = 1,len + 1
	while first < last do
		local pos = math.floor((last-first) / 2) + first
		if not cmp(t[pos],val) then
			last = pos
		else
			first = pos + 1
		end
	end
	if last > len then
		return nil
	else
		return last
	end
end

function uppper_bound(t,val,cmp)
	cmp = cmp or less_than
	local len = #t
	local first,last = 1,len + 1
	while first < last do
		local pos = math.floor((last-first)/2) + first
		if cmp(val,t[pos]) then
			last = pos
		else
			first = pos + 1
		end
	end
	if last > len then
		return nil
	else
		return last
	end
end

function equal(lhs,rhs)
	if lhs == rhs then
		return true
	end
	if type(lhs) == "table" and type(rhs) == "table" then
		local tmp = deepcopy(rhs)
		for k,v in pairs(lhs) do
			if equal(v,tmp[k]) then
				tmp[k] = nil
			end
		end
		if not next(tmp) then
			return true
		end
	end
	return false
end

--function xrange(b,e,step)
--	step = step or 1
--	if not e then
--		e = b
--		b = 1
--	end
--	return iter(range(b,e,step))
--end
--
---- same as pairs
--function iter(t)
--	local t = t
--	local k = nil
--	function _iter()
--		k,v = next(t,k)
--		return k,v
--	end
--	return _iter
--end



function slice(list,b,e,step)
	step = step or 1
	if not e then
		e = b
		b = 1
	end
	e = math.min(#list,e)
	local new_list = {}
	local len = #list
	local idx
	for i = b,e,step do
		idx = i >= 0 and i or len + i + 1
		table.insert(new_list,list[idx])
	end
	return new_list
end

function filter(t,func)
	assert(func ~= nil)
	local ret = {}
	for k,v in pairs(t) do
		if func(k,v) then
			ret[k] = v
		end
	end
	return ret
end

function map(func,...)
	local args = {...}
	assert(#args >= 1)
	local maxlen,num = 0,#args
	for i = 1, num do
		if #args[i] > maxlen then
			maxlen = #args[i]
		end
	end
	local ret = {}
	for i = 1, maxlen do
		local list = {}
		for j = 1, num do
			table.insert(list,args[j][i])
		end
		table.insert(ret,func(unpack(list)))
	end
	return ret
end

--copy
-------------------------------------------------------------
-- lua元素复制接口,提供浅复制(copy)和深复制两个接口(deepcopy)
-- 深复制解决以下3个问题:
-- 1. table存在循环引用
-- 2. metatable(metatable都不参与复制)
-- 3. keys也是table
--------------------------------------------------------------
function copy(o)
	local typ = type(o)
	if typ ~= "table" then return o end
	local newtable = {}
	for k,v in pairs(o) do
		newtable[k] = v
	end
	return setmetatable(newtable,getmetatable(o))
end


function deepcopy(o,seen)
	local typ = type(o)
	if typ ~= "table" then return o end
	seen = seen or {}
	if seen[o] then return seen[o] end
	local newtable = {}
	seen[o] = newtable
	for k,v in pairs(o) do
		newtable[deepcopy(k,seen)] = deepcopy(v,seen)
	end
	return setmetatable(newtable,getmetatable(o))
end

function updatetable(tbl1,tbl2)
	for k,v in pairs(tbl2) do
		tbl1[k] = v
	end
end

function findintable(tbl,val)
	for k,v in pairs(tbl) do
		if v == val then
			return k
		end
	end
end

--ratio
function ishit(num,limit)
	assert(limit >= num)
	limit = limit or 100
	return math.random(1,limit) <= num
end

function shuffle(list,inplace,limit)
	if not inplace then
		list = deepcopy(list)
	end
	local idx,tmp
	local len = #list
	for i = 1,len-1 do
		if limit and i > limit then
			return slice(list,1,limit)
		end
		idx = math.random(i,len)
		tmp = list[idx]
		list[idx] = list[i]
		list[i] = tmp
	end
	return list
end

function randlist(list)
	assert(#list > 0,"list length need > 0")
	local pos = math.random(1,#list)
	return list[pos],pos
end



function choosevalue(dct,func)
	local sum = 0
	for ratio,_ in pairs(dct) do
		sum = sum + (func and func(ratio) or ratio)
	end
	local hit = math.random(1,sum)
	local limit = 0
	for ratio,val in pairs(dct) do
		limit = limit + (func and func(ratio) or ratio)
		if hit <= limit then
			return val
		end
	end
	return nil
end

function choosekey(dct,func)
	local sum = 0
	for _,ratio in pairs(dct) do
		sum = sum + (func and func(ratio) or ratio)
	end
	assert(sum >= 1,"[choosekey] Invalid sum ratio:" .. tostring(sum))
	local hit = math.random(1,sum)
	local limit = 0
	for key,ratio in pairs(dct) do
		limit = limit + (func and func(ratio) or ratio)
		if hit <= limit then
			return key
		end
	end
	return nil
end

-- time
function gethourno(flag)
	local start = flag and STARTTIME2 or STARTTIME1
	local tm = os.time() - start
	return math.floor(tm/HOUR_SECS) + (tm % HOUR_SECS == 0 and 0 or 1)
end

function getdayno(flag)
	local start = flag and STARTTIME2 or STARTTIME1
	local tm = os.time() - start
	return math.floor(tm/DAY_SECS) + (tm % DAY_SECS == 0 and 0 or 1)
end

function getweekno(flag)
	local start = flag and STARTTIME2 or STARTTIME1
	local tm = os.time() - start
	return math.floor(tm/WEEK_SECS) + (tm % WEEK_SECS == 0 and 0 or 1)
end

function getsecond(now)
	return now or os.time()
end

function getyear(now)
	now = now or os.time()
	local s = os.date("%Y",now)
	return tonumber(s)
end

function getyearmonth(now)
	now = now or os.time()
	local s = os.date("%m",now)
	return tonumber(s)
end

function getmonthday(now)
	now = now or os.time()
	local s = os.date("%d",now)
	return tonumber(s)
end

--星期天为0
function getweekday(now)
	now = now or os.time()
	local s = os.date("%w",now)
	return tonumber(s)
end

function getdayhour(now)
	now = now or os.time()
	local s = os.date("%H",now)
	return tonumber(s)
end

function gethourminute(now)
	now = now or os.time()
	local s = os.date("%M",now)
	return tonumber(s)
end

function getminutesecond(now)
	now = now or os.time()
	local s = os.date("%S",now)
	return tonumber(s)
end

--当天过去的秒数
function getdaysecond(now)
	now = now or os.time()
	return getdayhour(now) * HOUR_SECS + gethourminute(now) * 60 + getminutesecond(now)
end

--当天0点时间(秒为单位)
function getdayzerotime(now)
	now = now or os.time()
	return getsecond(now) - getdaysecond(now)
end


-- 当周0点(星期一为一周起点)
function getweekzerotime(now)
	now = now or os.time()
	local weekday = getweekday(now)
	weekday = weekday == 0 and 7 or weekday
	local diffday = weekday - 1
	return getdayzerotime(now-diffday*DAY_SECS)
end

-- 当周0点（星期天为一周起点)
function getweek2zerotime(now)
	now = now or os.time()
	local weekday = getweekday(now)
	local diffday = weekday - 0
	return getdayzerotime(now-diffday*DAY_SECS)
end

-- 当月0点
function getmonthzerotime(now)
	now = now or os.time()
	local monthday = getmonthday(now)
	return getdayzerotime(now-monthday*DAY_SECS)
end

--string
function isdigit(str)
	local ret = pcall(tonumber,str)
	return ret
end

function hexstr(str)
	assert(type(str) == "string")
	local len = #str
	return string.format("0x" .. string.rep("%x",len),string.byte(str,1,len))
end

local WHITECHARS_PAT = "%S+"
function split(str,pat,maxsplit)
	pat = pat or WHITECHARS_PAT
	maxsplit = maxsplit or -1
	local ret = {}
	local i = 0
	for s in string.gmatch(str,pat) do
		if not (maxsplit == -1 or i <= maxsplit) then
			break
		end
		table.insert(ret,s)
	end
	return ret
end

--filesystem
function currentdir()
	local ok,ret = pcall(require,"lfs")
	if ok then
		return lfs.currentdir()
	end
	local fd = popen("pwd")
	local path = fd:read("*all")
	print (path)
	return path
end


-- package
function sendpackage(pid,protoname,cmd,args,onresponse)
	require "script.playermgr"
	require "script.proto.init"
	obj = playermgr.getobject(pid)
	if obj then
		if obj.__agent then
			proto.sendpackage(obj.__agent,protoname,cmd,args,onresponse)
		end
	end
end

function broadcast(func)
	require "script.playermgr"
	for pid,player in pairs(playermgr.id_obj) do
		if player then
			func(player)
		end
	end
end



-- 常用函数
function isvalid_name(name)
	return true
end

function isvalid_roletype(roletype)
	return true
end

function isvalid_accountname(account)
	return string.match(account,"%w+@%w+%.%w+")
end

function isvalid_passwd(passwd)
	return string.match(passwd,"^[%w_]+$")
end

function gethideip(ip)
	local hideip = ip:gsub("([^.]+)","*",2)
	return hideip
end


function checkargs(args,...)
	local typs = {...}
	if #typs == 0 then
		return true,args
	end
	local ret = {}
	for i = 1,#typs do
		if not args[i] then
			return nil,string.format("argument not enough(%d < %d)",#args,#typs)
		end
		if typs[i] == "*" then -- ignore check
			for j=i,#args do
				table.insert(ret,args[j])
			end
			return true,ret
		end
		local typ = typs[i]
		local range_begin,range_end
		local val
		local pos = string.find(typ,":")
		if pos then
			typ = typ:sub(1,pos-1)
			range_begin,range_end = string.match(typ:sub(pos+1),"%[([%d.]*),([%d.]*)%]")
			if not range_begin then
				range_begin = MIN_NUMBER
			end
			if not range_end then
				range_end = MAX_NUMBER
			end
			range_begin,range_end = tonumber(range_begin),tonumber(range_end)
		end
		if typ == "int" or typ == "double" then
			val = tonumber(args[i])
			if not val then
				return false,"invalid number:" .. tostring(args[i])
			end
			if typ == "int" then
				val = math.floor(val)
			end
			if range_begin and range_end then
				if not (range_begin <= val and val <= range_end) then
					return false,string.format("%s not in range [%s,%s]",val,range_begin,range_end)
				end
			end
			table.insert(ret,val)
		elseif typ == "boolean" then
			typ = string.lower(typ)
			if not (typ == "true" or typ == "false" or typ == "1" or typ == "0") then
				return false,"invalid boolean:" .. tostring(typ)
			end
			val = (typ == "true" or typ == "1") and true or false
			table.insert(ret,val)
		elseif typ == "string" then
			val = args[i]
			table.insert(ret,val)
		else
			return false,"unknow type:" ..tostring(typ)
		end
	end
	return true,ret
end

-- error
local function collect_localvar(level)
	level = level + 1 -- skip self function 'collect_localval'
	local function dumptable(tbl) 
		local attrs = {"pid","id","name","sid","warid","flag",}
		local tips = {}
		for _,attr in ipairs(attrs) do
			if tbl[attr] then
				table.insert(tips,string.format("\t%s=%s",attr,tbl[attr]))
			end
		end
		return tips
	end

	local ret = {}
	local i = 0
	while true do
		i = i + 1
		local name,value = debug.getlocal(level,i)
		if not name then
			break
		end
		
		table.insert(ret,string.format("%s=%s",name,value))
		if type(value) == "table" then
			local tips = dumptable(value)
			if #tips > 0 then
				table.insert(ret,table.concat(tips,"\n"))
			end
		end
	end
	return ret
end

function onerror(msg)
	local level = 4
	pcall(function ()
		-- assert/error触发(需要搜集level+1层--调用assert/error函数所在层)
		-- 代码逻辑直接触发搜集level层即可
		local vars = collect_localvar(level)
		table.insert(vars,"================")
		local vars2 = collect_localvar(level+1)
		for _,s in ipairs(vars2) do
			table.insert(vars,s)
		end
		table.insert(vars,1,string.format("[ERROR] [%s] %s",os.date("%Y-%m-%d %H:%M:%S"),msg))
		local msg = debug.traceback(table.concat(vars,"\n"),level)
		print(msg)
		logger.log("error","onerror",msg)
		--skynet.error(msg)
	end)
end

HEX_MAP = {}
for i=0,15 do
	local char
	if i >= 10 then
		char = string.char(97+i-10)
	else
		char = tostring(i)
	end
	tostring(i)
	HEX_MAP[i] = char
	HEX_MAP[char] = i
end


function uuid()
	local ret = {}
	for i=1,32 do
		table.insert(ret,HEX_MAP[math.random(0,0xf)])
	end
	return table.concat(ret,"")
end

-- 扩展表功能
function table.any(set,func)
	for k,v in pairs(set) do
		if func(k,v) then
			return true,k,v
		end
	end
	return false
end

function table.all(set,func)
	for k,v in pairs(set) do
		if not func(k,v) then
			return false,k,v
		end
	end
	return true
end

function table.filter(tbl,func)
	local newtbl = {}
	for k,v in pairs(tbl) do
		if func(k,v) then
			newtbl[k] = v
		end
	end
	return newtbl
end

function table.max(func,...)
	local args = table.pack(...)
	local max
	for i,arg in ipairs(args) do
		local val = func(arg)
		if not max or val > max then
			max = val
		end
	end
	return max
end

function table.min(func,...)
	local args = table.pack(...)
	local min
	for i,arg in ipairs(args) do
		local val = func(arg)
		if not min or val < min then
			min = val
		end
	end
	return min
end

function table.map(func,...)
	local args = table.pack(...)
	assert(#args >= 1)
	func = func or function (...)
		return {...}
	end
	local maxn = table.max(function (tbl)
			return #tbl
		end,...)
	local len = #args
	local newtbl = {}
	for i=1,maxn do
		local list = {}
		for j=1,len do
			table.insert(list,args[j][i])
		end
		local ret = func(table.unpack(list))
		table.insert(newtbl,ret)
	end
	return newtbl
end

function table.broadcast(tbl,func)
	table.map(func,tbl)
end

function table.find(tbl,func)
	local isfunc = type(func) == "function"
	for k,v in pairs(tbl) do
		if isfunc then
			if func(k,v) then
				return k,v
			end
		else
			if func == v then
				return k,v
			end
		end
	end
end

function table.dump(t,space,name)
	space = space or ""
	name = name or ""
	local cache = { [t] = "."}
	local function _dump(t,space,name)
		local temp = {}
		for k,v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				table.insert(temp,"+" .. key .. " {" .. cache[v].."}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				table.insert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. string.rep(" ",#key),new_key))
			else
				table.insert(temp,"+" .. key .. " [" .. tostring(v).."]")
			end
		end
		return table.concat(temp,"\n"..space)
	end
	return _dump(t,space,name)
end

-- 扩展string
function string.rtrim(str)
	return string.match(str,"^(%s-[^%s]*)%s*$")
end

function string.ltrim(str)
	return string.match(str,"^%s*(.*)$")
end

function string.trim(str)
	str = string.ltrim(str)
	return string.rtrim(str)
end
