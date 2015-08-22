----------------------------------------------------------
--功能: 给lua oop提供原语class
--用例: 参考测试脚本:test_class.lua
--参考: blog.codingnow.com/cloud/LuaOO
----------------------------------------------------------
_class = _class or {}
function class(...)
	local super = {...}
	local class_type = {}
	class_type.init = false		--constructor
	class_type.super = super
	class_type.new = function (...)
		local tmp = ...
		assert(tmp ~= class_type,"must use class_type.new(...) but not class_type:new(...)")
		local obj = {}
		obj.__type__ = class_type
		setmetatable(obj,{__index = _class[class_type]});
		do
			--function create(class_type,...)
			--	for _,super_type in pairs(class_type.super) do
			--		create(super_type,...)
			--	end
			--	if class_type.init then
			--		class_type.init(obj,...)
			--	end
			--end
			--create(class_type,...)
			if class_type.init then
				class_type.init(obj,...)
			end
		end
		return obj
	end
	local vtb = {}
	_class[class_type] = vtb
	--print("_class",class_type)
	setmetatable(class_type,{__index = vtb,__newindex =
		function (t,k,v)
			--print("class_type.__newindex",t,k,v)
			vtb[k] = v
		end
	})
	setmetatable(vtb,{__index =
		function (t,k)
			for _,super_type in pairs(class_type.super) do
				if _class[super_type][k] then
					--print("vtb.__index",super_type,k)
					vtb[k] = _class[super_type][k]
					return _class[super_type][k]
				end
			end
		end
	})
	return class_type
end

-- 必须保证类定义完整被begin_declare,end_declare包含
_oldclass_cache = _oldclass_cache or {}

function begin_declare(flag,cls)
	--print("begin_declare",flag,cls)
	if cls then
		if not _oldclass_cache[flag] then
			_oldclass_cache[flag] = {}
		end
		table.insert(_oldclass_cache[flag],cls)
	end
end

function end_declare(flag,cls)
	--print("end_declare",flag,cls)
	local oldclasses = _oldclass_cache[flag] or {}
	for _,oldclass in pairs(oldclasses) do
		-- 更新继承层次
		for k,v in pairs(cls) do
			--print("self",k,v)
			oldclass[k] = v
		end
		--清空旧类方法（包括旧类缓存的父类方法)
		for k,v in pairs(_class[oldclass]) do
			_class[oldclass][k] = nil
		end
		-- 更新类本身属性
		for k,v in pairs(_class[cls]) do
			_class[oldclass][k] = v
			--print("vtb",k,v)
		end
		--print("oldclass",oldclass)
		print("reload " .. tostring(flag))
	end
end

