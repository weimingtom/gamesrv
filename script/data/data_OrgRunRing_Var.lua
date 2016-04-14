--<<data_OrgRunRing_Var 导表开始>>
data_OrgRunRing_Var = {

		circle_limit = 100, 		--总环数限制

		nowcircle_limit = 20, 		--当前环数每逢20环重置

		final_bonus = {{type=2,value={[2]=1000000,}}}, 		--最终环奖励

		chujian_bonus = {{type=2,value={[1]=1000000,}}}, 		--除奸环奖励

		exp_formula = "return (exp*0.5)/20+(exp*0.5)*(nowcircle/210)", 		--经验奖励公式

		ap_formula = "return (ap*0.5)/20+(ap*0.6)*(nowcircle/210)", 		--成就奖励公式

}
return data_OrgRunRing_Var
--<<data_OrgRunRing_Var 导表结束>>