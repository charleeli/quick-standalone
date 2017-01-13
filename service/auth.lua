local skynet = require "skynet"
local service = require "service"
local client = require "client"

local auth = {}
local users = {}
local cli = client.handler()

local SUCC = { ok = true }
local FAIL = { ok = false }

function cli:signup(args)
	LOG_INFO("signup userid = %s", args.userid)
	if users[args.userid] then
		return FAIL
	else
		users[args.userid] = true
		return SUCC
	end
end

function cli:signin(args)
	LOG_INFO("signin userid = %s", args.userid)
	if users[args.userid] then
		self.userid = args.userid
		self.exit = true
		return SUCC
	else
		return FAIL
	end
end

function cli:ping()
	LOG_INFO("ping")
end

function auth.shakehand(fd)
	local c = client.dispatch { fd = fd }
	return c.userid
end

service.init {
	command = auth,
	info = users,
	init = client.init "proto",
}
