require "script.test.test_class.classa1"
require "script.test.test_class.classa2"
require "script.test.test_class.classb"
require "script.test.test_class.classc"

local function test()
	local oc = classc.new("oc's param")
	assert(oc.param == "oc's param")
	local ob = classb.new("ob's param")
	assert(ob.param == "ob's param")
	assert(oc.param == "oc's param")

	local oa1 = classa1.new()
	assert(oa1.desc==classa1.desc)
	local oa2 = classa2.new()
	assert(oa2.desc==classa2.desc)

	assert(ob.desc==classa1.desc)
	assert(oc.desc==classa1.desc)
	-- old is "this is classa2's description"
	classa2.desc = "change classa2's description"
	assert(ob.desc==classa1.desc)
	assert(oc.desc==classa1.desc)
	assert(oa2.desc == "change classa2's description")
	-- 热更新classa2不影响oc/ob的desc字段，他们用的是缓存的classa1的desc字段
	hotfix.hotfix("script.test.test_class.classa2")
	assert(ob.desc==classa1.desc)
	assert(oc.desc==classa1.desc)

	-- old is "this is classa1's description"
	classa1.desc = "change classa1's description"
	assert(oa1.desc==classa1.desc)
	assert(oa2.desc==classa2.desc)
	assert(ob.desc=="this is classa1's description")
	assert(oc.desc=="this is classa1's description")
	hotfix.hotfix("script.test.test_class.classa1")
	assert(ob.desc==classa1.desc) -- "change classa1's description"
	--print(oc.desc)
	assert(oc.desc==classa1.desc)
end

return test

