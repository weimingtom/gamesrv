net = net or {}
function net.init()
	net.test = require "script.net.test"
	net.login = require "script.net.login"
	net.msg = require "script.net.msg"
	net.player = require "script.net.player"
	net.friend = require "script.net.friend"
	net.war = require "script.net.war"
	net.mail = require "script.net.mail"
	net.team = require "script.net.team"
	net.scene = require "script.net.scene"
	net.task = require "script.net.task"
end
return net
