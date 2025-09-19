--!native
--!optimize 2

--[[
	Exists so that the namespace can set the ID of the packet

	Packet shouldnt need to care about making its own ID
]]
local packet = require(script.Parent.packet)

return function(direction: string, value: any, reliability: string?)
	if direction ~= "client->server" and direction ~= "server->client" then
		error("Argument 'direction' must be 'server-client' or 'client->server'")
	end

	reliability = reliability or "reliable"
	if reliability ~= "reliable" and reliability ~= "unreliable" then
		error("Argument 'reliability' must be 'reliable' or 'unreliable'")
	end

	return function(id: number)
		return packet(value, direction, reliability == "reliable", id)
	end
end
