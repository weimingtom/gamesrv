--<<data_formula 导表开始>>
data_formula = {

	[1] = {
		formula = "return math.floor((player_shimen_circle/55) * data_exp_shimen[player_team_follow_avglv2].exp)",
		param = {player_shimen_circle=1,data_exp_shimen=1,player_team_follow_avglv2=1},
		desc = "(师门环数/55)*队伍平均等级对应的基础经验,结果向下取整",
		purpose = "师门任务",
		compile_formula = nil,
	},

	[2] = {
		formula = "return player_lv*10+1000",
		param = {player_lv=1},
		desc = "玩家等级*10+100",
		purpose = "补偿邮件",
		compile_formula = nil,
	},

}
return data_formula
--<<data_formula 导表结束>>
