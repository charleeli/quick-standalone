local skynet = require "skynet"
local proxy = require "socket_proxy"
local sprotoloader = require "sprotoloader"
local sproto_env = require "sproto_env"

local client = {}
local host
local sender
local handler = {}

function client.handler()
	return handler
end

function client.dispatch( c )
	local fd = c.fd
	proxy.subscribe(fd)
	local ERROR = {}
	while true do
		local msg, sz = proxy.read(fd)
		local type, name, args, response = host:dispatch(msg, sz)
		assert(type == "REQUEST")
		if c.exit then
			return c
		end
		local f = handler[name]
		if f then
			-- f may block , so fork and run
			skynet.fork(function()
				local ok, result = pcall(f, c, args)
				if ok then
					proxy.write(fd, response(result))
				else
					LOG_ERROR("raise error = %s", result)
					proxy.write(fd, response(ERROR, result))
				end
			end)
		else
			-- unsupported command, disconnected
			error ("Invalid command " .. name)
		end
	end
end

function client.close(fd)
	proxy.close(fd)
end

function client.push(c, t, data)
	proxy.write(c.fd, sender(t, data))
end

function client.init(name)
	return function ()
		local c2s_sp = sprotoloader.load(sproto_env.PID_C2S)
		host = c2s_sp:host(sproto_env.PACKAGE)
		local s2c_sp = sprotoloader.load(sproto_env.PID_S2C)
		sender = host:attach(s2c_sp)
	end
end

return client