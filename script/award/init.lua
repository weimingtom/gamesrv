
--[[
奖励控制表格式:
{
	{
		type = 1/2 #1--独立计算概率(概率基数为1000000)，2-－互斥概率
		value = {
			[awardid1] = ratio1,
			[awardid2] = ratio2,
			...
		}
	},
	...
}

奖励项格式：
{
	type = 资源ID/物品ID,
	num = 数量,
	#其他字段，如对于物品，bind字段
}
]]

award = award or {}
function award.orgaward(orgid,reward)
end

local BASE_RATIO = BASE_RATIO or 1000000
function award.__player(pid,bonus,reason,btip)
	local lackbonus
	local player = playermgr.getplayer(pid)
	if player then
		local num
		if bonus.__formula then
			bonus = deepcopy(bonus)
			bonus.__formula = nil
			bonus.num = execformula(player,bonus.num)
		end
		local hasbonus_num
		if isres(bonus.type) then
			hasbonus_num = player:addres(bonus.type,bonus.num,reason,btip)
		elseif isitem(bonus.type) then
			hasbonus_num = player:additem2(bonus,reason,btip)
		else
			error("Invalid restype:" .. tostring(bonus.type))
		end
		-- 资源过剩是否发邮件?
		if not isres(bonus.type) then
			if bonus.num > hasbonus_num then
				lackbonus = deepcopy(bonus)
				lackbonus.num = bonus.num - hasbonus_num
			end
		end
	else
		lackbonus = deepcopy(bonus)
	end
	return lackbonus

end

function award.player(pid,rewards,reason,btip)
	local lackbonuss = {}
	for i,reward in ipairs(rewards) do
		if reward.type == 1 then
			reward = reward.value
			for awardid,ratio in pairs(reward) do
				if ishit(ratio,BASE_RATIO) then
					local bonus = getaward(awardid)
					bonus = bonus.award
					local lackbonus = award.__player(pid,bonus,reason,btip)
					table.insert(lackbonuss,lackbonus)
				end
			end
		else
			assert(reward.type==2)
			reward = reward.value
			local bonus = choosekey(reward)
			local lackbonus = award.__player(pid,bonus,reason,btip)
			table.insert(lackbonuss,lackbonus)	
		end
	end
	-- 1.玩家不在线，2.由于背包不足/资源过剩没有加到的资源/物品,需要发邮件，这里合并（只发）一封邮件
	if next(lackbonuss) then
		mailmgr.sendmail(pid,{
			srcid = SYSTEM_MAIL, author = "系统",
			title = "奖励",
			content = "",
			attach = lackbonuss,
		})
	end
end

function award.org(orgid,rewards,reason,btip)
end


function doaward(typ,id,rewards,reason,btip)
	local func = assert(award[typ],"Invalid cmd:" .. tostring(cmd))

	local srvname = getsrvname(typ,id)
	logger.log("info","award",format("doaward,srvname=%s typ=%s id=%d rewards=%s reason=%s btip=%s",srvname,typ,id,rewards,reason,btip))
	return func(id,rewards,reason,btip)
end

function getsrvname(typ,id)
	if typ == "player" then
		return route.getsrvname(id)
	elseif typ == "org" then
		-- TODO:
	end
end

function isres(typ)
	return typ <= MAX_RESTYPE
end

function isitem(typ)
	-- TODO: MODIFY
	return typ > MAX_RESTYPE
end

function getaward(awardid)
	return data_award[awardid]
end

return award
