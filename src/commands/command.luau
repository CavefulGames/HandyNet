--!native
--!optimize 2

local RunService = game:GetService("RunService")

local packet = require(script.Parent.Parent.packets.packet)
local nothing = require(script.Parent.Parent.dataTypes.nothing)()

local moduleRunContext: "server" | "client" = if RunService:IsServer() then "server" else "client"

return function(fn: () -> (), reliable: boolean, id: number)
	local innerPacket = packet(nothing, reliable, id)
	local command

	if moduleRunContext == "server" then
		innerPacket.onServerReceived:connect(fn)

		command = function(player: Player?)
			if player then
				innerPacket.sendTo(nil, player)
			else
				innerPacket.broadcast(nil)
			end
		end
	elseif moduleRunContext == "client" then
		innerPacket.onClientReceived:connect(fn)

		command = function()
			innerPacket.sendToServer(nil)
		end
	end

	return command
end
