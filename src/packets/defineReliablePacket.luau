--!native
--!optimize 2

--[[
	Exists so that the namespace can set the ID of the packet

	Packet shouldnt need to care about making its own ID
]]
local packet = require(script.Parent.packet)

return function(value: any)
	return function(id: number)
		return packet(value, true, id)
	end
end
