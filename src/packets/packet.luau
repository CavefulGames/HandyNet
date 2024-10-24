--!native
--!optimize 2

local RunService = game:GetService("RunService")

local types = require(script.Parent.Parent.types)
local client = require(script.Parent.Parent.process.client)
local server = require(script.Parent.Parent.process.server)
local LimeSignal = require(script.Parent.Parent.Parent.limesignal)
local emitter = require(script.Parent.Parent.emitter)

local moduleRunContext: "server" | "client" = if RunService:IsServer() then "server" else "client"

--[[
	We use closures here instead of metatables for performance
	It's just faster to use closures than metatables
]]
return function(value: types.dataTypeInterface<any>, direction: "client->server" | "server->client", reliable: boolean, id: number)
	local exported = {}

	if direction == "server->client" then
		if moduleRunContext == "server" then
			local writer = value.write

			local serverSendFunction: (player: Player, id: number, writer: (value: any) -> (), data: any) -> () = if reliable
				then server.sendPlayerReliable
				else server.sendPlayerUnreliable

			local serverSendAllFunction: (id: number, writer: (value: any) -> (), data: any) -> () = if reliable
				then server.sendAllReliable
				else server.sendAllUnreliable

			function exported.send(data, player: Player?)
				if player then
					serverSendFunction(player, id, writer, data)
				else
					serverSendAllFunction(id, writer, data)
				end
			end
		elseif moduleRunContext == "client" then
			exported.reader = value.read
			exported.event = LimeSignal.Event.from(emitter)
		end
	elseif direction == "client->server" then
		if moduleRunContext == "client" then
			local writer = value.write

			local clientSendFunction: (id: number, writer: (value: any) -> (), data: any) -> () = if reliable
				then client.sendReliable
				else client.sendUnreliable

			function exported.send(data)
				clientSendFunction(id, writer, data)
			end
		elseif moduleRunContext == "server" then
			exported.reader = value.read
			exported.event = LimeSignal.Event.from(emitter)
		end
	end

	return exported
end
