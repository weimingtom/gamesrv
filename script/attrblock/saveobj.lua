--/*
-- 自动存盘管理器，纳入管理的对象必须实现以下函数：
-- xx:savetodatabase()
-- xx.savename = 存盘对象标示名字，方便人类理解
-- 具体用法见：script/test/test_saveobj.lua
-- 切记对象销毁后调用closesave关闭存盘
--*/

local SAVE_DELAY = SAVE_DELAY or 300
__saveobjs = __saveobjs or setmetatable({},{__mode="kv",})
print("old saveobj id:",__saveobj_id)
__saveobj_id = __saveobj_id or 0



local onerror = onerror or function (err)
	local msg = string.format("[ERROR] %s %s\n",os.date("%Y-%m-%d %H:%M:%S"),err)
		.. debug.traceback()
	logger.log("error","onerror",msg)
end

local function ontimer(id)
	local obj = get_saveobj(id)
	--printf("saveobjs:%s",keys(__saveobjs))
	if obj then
		local flag = uniqueflag(obj)
		logger.log("info","saveobj",string.format("[ontimer] uniqueflag=%s",flag))
		timer.timeout(flag,SAVE_DELAY,functor(ontimer,obj.__saveobj_id))
		nowsave(obj)
	end
end

local function starttimer(obj)
	local flag = uniqueflag(obj)
	logger.log("info","saveobj",string.format("starttimer uniqueflag=%s",flag))
	timer.timeout(flag,SAVE_DELAY,functor(ontimer,obj.__saveobj_id))
end

function add_saveobj(obj)
	local id = assert(obj.__saveobj_id)
	assert(__saveobjs[id] == nil,"repeat saveobj id:" .. tostring(id))
	logger.log("info","saveobj",string.format("[add_saveobj] uniqueflag=%s",uniqueflag(obj)))
	__saveobjs[id] = obj
end


function del_saveobj(obj)
	local id = obj.__saveobj_id
	local saveobj = get_saveobj(id)
	if saveobj then
		assert(obj == saveobj)
		logger.log("info","saveobj",string.format("[del_saveobj] uniqueflag=%s",uniqueflag(saveobj)))
		__saveobjs[id] = nil
	end
	-- not savetodatabase
end

function get_saveobj(id)
	return __saveobjs[id]
end

function saveall()
	logger.log("info","saveobj","[saveall]")
	for id,obj in pairs(__saveobjs) do
		nowsave(obj)
	end
end

-- 初始化存盘对象
function opensave(obj,name)
	-- 忽略临时对象
	if obj.__temp then
		return
	end
	obj.__saveobj_name = assert(name)
	local id = obj.__saveobj_id
	local saveobj = get_saveobj(id)
	if not saveobj then
		__saveobj_id = __saveobj_id + 1
		obj.__saveobj_id = __saveobj_id
		obj.mergelist = {}
		add_saveobj(obj)
		starttimer(obj)
	else
		assert(obj == saveobj,"conflict saveobj id:" .. tostring(id))
	end
	return obj
end

-- 关闭存盘对象
function closesave(obj)
	del_saveobj(obj)
	obj.__saveobj_name = nil
	obj.__saveobj_id = nil
	obj.mergelist = nil
	obj.savetype = nil
end

function isopensave(obj)
	local id = obj.__saveobj_id
	if get_saveobj(id) then
		return true
	end
	return false
end

function autosave(obj)
	if obj.savetype == "oncesave" then
		error("if you want to change 'oncesave' to 'autosave',use function 'clearsavetype' before!")
	end
	obj.savetype = "autosave"
	if not isopensave(obj) then
		assert(obj.savename,"属性'savename'未设置")
		local name = string.format("%s.%s",obj.savename,obj.pid)
		opensave(obj,name)
	end
	logger.log("info","saveobj",string.format("[autosave] uniqueflag=%s",uniqueflag(obj)))
end

function oncesave(obj)
	if obj.savetype == "autosave" then
		error("if you want to change 'autosave' to 'oncesave',use function 'clearsavetype' before!")
	end
	obj.savetype = "oncesave"
	if not isopensave(obj) then
		assert(obj.savename,"属性'savename'未设置")
		local name = string.format("%s.%s",obj.savename,obj.pid)
		opensave(obj,name)
	end
	logger.log("info","saveobj",string.format("[oncesave] uniqueflag=%s",uniqueflag(obj)))
end

function nowsave(obj)
	if obj.savetype == "oncesave" or obj.savetype == "autosave" then
		xpcall(function ()
			obj:savetodatabase()
			local mergelist = obj.mergelist or {}
			local mergeliststr = {}
			for id,obj in pairs(mergelist) do
				table.insert(mergeliststr,uniqueflag(obj))
			end
			mergeliststr = table.concat(mergeliststr,"->")
			logger.log("info","saveobj",string.format("[nowsave] uniqueflag=%s mergelist=%s",uniqueflag(obj),mergeliststr))
			obj.mergelist = {}
			for id,mergeobj in pairs(mergelist) do
				obj.mergelist[id] = nil
				if mergeobj.mergelist[obj.__saveobj_id] then
					mergeobj.mergelist[obj.__saveobj_id] = nil
				end
				nowsave(mergeobj)
			end
		end,onerror)
	else
		if obj.savetype ~= "oncesaved" then
			logger.log("warning","saveobj",string.format("[unknow savetype] uniqueflag=%s,maybe not call autosave/nowsave after clearsavetype",uniqueflag(obj)))
		end
	end
	if obj.savetype == "oncesave" then
		obj.savetype = "oncesaved"
	end
end

--/*
-- 关联存牌对象,将obj1的存盘和obj2关联，即obj2存盘时，obj1也同时存盘，存盘后关联效果将失效
--*/
function mergeto(obj1,obj2)
	local id = assert(obj1.__saveobj_id)
	logger.log("info","saveobj",string.format("[mergeto] obj1=%s obj2=%s",uniqueflag(obj1),uniqueflag(obj2)))
	obj2.mergelist[id] = obj1
end


--/*
-- 清空存盘标记，一般用于切换存盘类型前，如autosave->clearsavetype->oncesave / oncesave->clearsavetype->autosave
--*/
function clearsavetype(obj)
	local flag = uniqueflag(obj)
	logger.log("info","saveobj",string.format("[clearsavetype] uniqueflag=%s",flag))
	obj.savetype = nil
end

function uniqueflag(obj)
	return string.format("%s(type=%s name=%s addr=%s)",obj.__saveobj_id,obj.savetype,obj.savename,tostring(obj))
end

