--<<data_task_shimen 导表开始>>
data_task_shimen = {

	[3050001] = {
		name = "与人对话",
		param = {npcid=20000001,talkid=10001},
		award = {{type=1,value={[1]=100,[2]=200}},},
		help_award = {},
		openlv = 30,
		pretask = 0,
		nexttask = {[3020002]=1,[3010003]=1,[3040004]=1},
		autoaccept = 1,
		autosubmit = 1,
		desc = [[]],
		award_desc = [[]],
		help_award_desc = [[]],
	},

	[3020002] = {
		name = "巡逻遇怪",
		param = {posid=10001,warid=10001},
		award = {{type=1,value={[1]=100,[2]=200}},},
		help_award = {},
		openlv = 30,
		pretask = 0,
		nexttask = {[3020001]=1,[3010003]=1,[3040004]=1},
		autoaccept = 1,
		autosubmit = 1,
		desc = [[]],
		award_desc = [[]],
		help_award_desc = [[]],
	},

	[3010003] = {
		name = "给予物品",
		param = {type=10000001,num=1},
		award = {{type=1,value={[1]=100,[2]=200}},},
		help_award = {},
		openlv = 30,
		pretask = 0,
		nexttask = {[3020002]=1,[3010001]=1,[3040004]=1},
		autoaccept = 1,
		autosubmit = 1,
		desc = [[]],
		award_desc = [[]],
		help_award_desc = [[]],
	},

	[3040004] = {
		name = "给予宠物",
		param = {type=101,num=1},
		award = {{type=1,value={[1]=100,[2]=200}},},
		help_award = {},
		openlv = 30,
		pretask = 0,
		nexttask = {[3020002]=1,[3010003]=1,[3040001]=1},
		autoaccept = 1,
		autosubmit = 1,
		desc = [[]],
		award_desc = [[]],
		help_award_desc = [[]],
	},

}
return data_task_shimen
--<<data_task_shimen 导表结束>>