netcluster = netcluster or {}

function netcluster.init()
	require "script.server"
	netcluster.route = require "script.cluster.route"
	netcluster.playermethod = require "script.cluster.playermethod"
	netcluster.modmethod = require "script.cluster.modmethod"
	netcluster.forward = require "script.cluster.forward"
	netcluster.resumemgr = require "script.resume.resumemgr"
	if cserver.iswarsrv() then
		netcluster.war = require "script.cluster.warsrv"
	end
	if cserver.iswarsrvmgr() then
		netcluster.war = require "script.cluster.warsrvmgr"
	end
	if cserver.isgamesrv() then
		netcluster.war = require "script.cluster.gamesrv"
	end
end

function __hotfix(oldmod)
	netcluster.init()
end

return netcluster
