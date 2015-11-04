--<<data_formula 导表开始>>
data_formula = {

	[1] = {
		formula = "return math.floor((player_shimen_circle/55) * data_exp_shimen[player_team_follow_avglv2].exp)",
		param = {“player_shimen_circle”,”data_exp_shimen”,”player_team_follow_avglv2”},
		desc = "(师门环数/55)*队伍平均等级对应的基础经验,结果向下取整",
		compile_formula = nil,
	},

}
return data_formula
--<<data_formula 导表结束>>
