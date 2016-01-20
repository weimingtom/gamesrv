
local SAVE_DELAY = SAVE_DELAY or 300
__saveobjs = __saveobjs or setmetatable({},{__mode="kv",})
print("old saveobj id:",__saveobj_id)
__saveobj_id = __saveobj_id or 0

function add_saveobj(obj)
	__saveobj_id = __saveobj_id + 1
	assert(__saveobjs[__saveobj_id] == nil,"repeat saveobj id:" .. tostring(__saveobj_id))
	__saveobjs[__saveobj_id] = obj
	obj.__saveobj_id = __saveobj_id
	logger.log("info","saveobj",string.format("add_saveobj %s",obj:uniqueflag()))
end


function del_saveobj(obj)
	logger.log("info","saveobj",string.format(" del_saveobj %s",obj:uniqueflag()))
	local id = obj.__saveobj_id
	__saveobjs[id] = nil
	-- not savetodatabase
end

function get_saveobj(id)
	return __saveobjs[id]
end

function saveall()
	logger.log("info","saveobj","saveall")
	for id,obj in pairs(__saveobjs) do
		if obj.saveflag ~= "autosave" then
			obj:oncesave()
		end
		obj:nowsave()
	end
end

local onerror = onerror or function (err)
	msg = string.format("[ERROR] %s %s\n",os.date("%Y-%m-%d %H:%M:%S"),err)
		.. debug.traceback()
	--logger.log("error","saveobj",msg)
	--skynet.error(msg)
	logger.log("error","onerror",msg)
end

local function ontimer(id)
	local obj = get_saveobj(id)
	--printf("saveobjs:%s",keys(__saveobjs))
	if obj then
		local flag = obj:uniqueflag()
		logger.log("info","saveobj",string.format("%s ontimer",flag))
		timer.timeout(flag,SAVE_DELAY,functor(ontimer,obj.__saveobj_id))
		obj:nowsave()
	end
end

local function starttimer(obj)
	local flag = obj:uniqueflag()
	logger.log("info","saveobj",string.format("%s starttimer",flag))
	timer.timeout(flag,SAVE_DELAY,functor(ontimer,obj.__saveobj_id))
end


csaveobj = class("csaveobj")
function csaveobj:init(conf)
	self.__saveobj_flag = conf.flag
	self.pid = conf.pid
	self.mergelist = setmetatable({},{__mode = "kv"})
	self.saveflag = false
	self.loadstate = "unload"
	if not self.__temp then
		add_saveobj(self)
	end
end

function csaveobj:autosave()
	assert(self.saveflag ~= "oncesave","autosave conflict with oncesave")
	logger.log("info","saveobj",string.format(" %s autosave",self:uniqueflag()))
	self.saveflag = "autosave"
	-- avoid multi starttimer
	if not self.__bstarttimer then
		self.__bstarttimer = true
		starttimer(self)
	end
end

function csaveobj:merge(obj)
	local id = obj.__saveobj_id
	assert(type(id) == "number","saveobj invalid id type:" .. tostring(type(id)))
	logger.log("info","saveobj",string.format("%s merge %s",self:uniqueflag(),obj:uniqueflag()))
	self.mergelist[id] = obj
end

function csaveobj:oncesave()
	assert(self.saveflag ~= "autosave","oncesave conflict with autosave")
	logger.log("info","saveobj",string.format("%s oncesave",self:uniqueflag()))
	self.saveflag = "oncesave"
end

function csaveobj:savetodatabase()
	logger.log("info","saveobj",string.format("%s savetodatabase",self:uniqueflag()))
--	if self.loadstate == "loaded" then
--		--TODO:
--	end
end

function csaveobj:loadfromdatabase()
	logger("info","saveobj",string.format("%s loadfromdatabase",self:uniqueflag()))
--	if not self.loadstate or self.loadstate == "unload" then
--		self.loadstate = "loading"
--		--TODO:
--		self.loadstate = "loaded"
--	end
end

function csaveobj:nowsave()
	if self.saveflag == "oncesave" or self.saveflag == "autosave" then
		xpcall(function ()
			self:savetodatabase()
			local mergeliststr = {}
			for i,v in ipairs(self.mergelist) do
				table.insert(mergeliststr,v:uniqueflag())
			end
			mergeliststr = table.concat(mergeliststr,"->")
			logger.log("info","saveobj",string.format("%s nowsave, mergelist=%s",self:uniqueflag(),mergeliststr))
			local mergelist = self.mergelist
			self.mergelist = {}
			for id,mergeobj in pairs(mergelist) do
				self.mergelist[id] = nil
				if mergeobj.mergelist[self.__saveobj_id] then
					mergeobj.mergelist[self.__saveobj_id] = nil
				end
				mergeobj:nowsave()
			end
		end,onerror)
	end
	if self.saveflag == "oncesave" then
		self.saveflag = false
	end
end

function csaveobj:clearsaveflag()
	local flag = self:uniqueflag()
	logger.log("info","saveobj",string.format("%s clearsaveflag",flag))
	self.saveflag = false
	timer.untimeout(flag)
end

function csaveobj:uniqueflag()
	return string.format("%s.%s(id=%s addr=%s)",self.__saveobj_flag,self.__saveobj_id,self.pid,tostring(self))
end


