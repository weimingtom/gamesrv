require "script.playermgr"
require "script.logger"

function doaward(pid,award,bsendmail,reason)
	if type(award) == "number" then
		award = getaward(award)
	end
	local srvname = route.getsrvname(pid)
	logger.log("info","award",format("doaward,srvname=%s pid=%d award=%s bsendmail=%s reason=%s",srvname,pid,award,bsendmail,reason))
	local player = playermgr.getplayer(pid)
	if player then
		if award.gold and award.gold > 0 then
			player:addgold(award.gold,reason)
		end
		if award.chip and award.chip > 0 then
			player:addchip(award.chip,reason)
		end
		if award.items and next(award.items) then
			player:additems(award.items,reason)
		end
	else
		if bsendmail then
			if not srvname then
				return false
			end
			return mailmgr.sendmail(pid,{
					srcid = SYSTEM_MAIL,
					author = "系统",
					title = "奖励",
					content = "",
					attach = {
						gold = award.gold,
						chip = award.chip,
						items = award.items,
					}
				})
		end
	end
	return true
end

function getaward(awardid)
	return data_award[awardid]
end
