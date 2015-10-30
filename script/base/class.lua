----------------------------------------------------------
--功能: 给lua oop提供原语class,支持热更新，支持父类热更新直接
--反应到子类,不支持删除成员函数，需要屏蔽时可以写成空函数
--用例: 参考测试脚本:script/test/test_class/init.lua
--参考: blog.codingnow.com/cloud/LuaOO
----------------------------------------------------------
__class = __class or {}
local function reload_class(name)
	local class_type = assert(__class[name],"try to reload a non-exist class")
	local vtb = __class[class_type]
	assert(vtb ~= nil,"class without vtb")
	-- 清空类缓存的父类方法
	for k,v in pairs(vtb) do
		vtb[k] = nil
	end
	local super = class_type.__super
	for _,super_class in pairs(super) do
		if super_class.__child then
			super_class.__child[class_type.__name] = true
		end
	end
	--print(string.format("reload class,name=%s class_type=%s vtb=%s",name,class_type,vtb))
	return class_type
end

local function update_hierarchy(name)
	local class_type = assert(__class[name],"try to update_hierarchy a non-exist class")
	reload_class(name)
	for name,_ in pairs(class_type.__child) do
		update_hierarchy(name)
	end
end

local function ajust_super(super)
	local pos
	for i,super_class in pairs(super) do
		if not super_class.__child then
			pos = i
			break
		end
	end
	if pos then
		local selfattr = table.remove(super,pos)
		table.insert(super,1,selfattr)
	end
	return super
end

-- 保证每个类名不同
function class(name,...)
	local super = {...}
	local class_type
	if not __class[name] then
		class_type = {}
		class_type.__child = {}
	else
		class_type = __class[name]
	end
	class_type.__name = name
	class_type.__super = ajust_super(super)
	class_type.init = false		--constructor
	local function new(istemp)
		return function (...)
			local tmp = ...
			assert(tmp ~= class_type,"must use class_type.new(...) but not class_type:new(...)")
			local self = {}
			if istemp then
				self.__temp = true
			end
			self.__type = class_type
			setmetatable(self,{__index = class_type});
			do
				if class_type.init then
					class_type.init(self,...)
				end
			end
			return self
		end
	end
	class_type.new = new(false)
	class_type.newtemp = new(true)
	if not __class[name] then -- if not getmetatable(class_type) then
		local vtb = {}	-- 仅用于缓存父类方法
		__class[name] = class_type
		__class[class_type] = vtb
		setmetatable(class_type,{__index = vtb,})
		setmetatable(vtb,{__index =
			function (t,k)
				for _,super_type in ipairs(class_type.__super) do
					local result = super_type[k]
					if result then
						vtb[k] = result
						return result
					end
				end
			end
		})
	end
	update_hierarchy(name)
	return class_type
end

