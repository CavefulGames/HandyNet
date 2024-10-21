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
return function(value: types.dataTypeInterface<any>, reliable: boolean, id: number)
	local serverSendFunction: (player: Player, id: number, writer: (value: any) -> (), data: any) -> () = if reliable
		then server.sendPlayerReliable
		else server.sendPlayerUnreliable

	local serverSendAllFunction: (id: number, writer: (value: any) -> (), data: any) -> () = if reliable
		then server.sendAllReliable
		else server.sendAllUnreliable

	local clientSendFunction: (id: number, writer: (value: any) -> (), data: any) -> () = if reliable
		then client.sendReliable
		else client.sendUnreliable

	-- shorcut to avoid indexxing
	local writer = value.write

	local exported = {}

	-- exposed for the reader file
	exported.reader = value.read

	if moduleRunContext == "server" then

		function exported.sendTo(data, player: Player)
			serverSendFunction(player, id, writer, data)
		end

		function exported.broadcast(data)
			serverSendAllFunction(id, writer, data)
		end

		exported.onServerReceived = LimeSignal.Event.from(emitter)
	elseif moduleRunContext == "client" then
		function exported.sendToServer(data)
			clientSendFunction(id, writer, data)
		end

		exported.onClientReceived = LimeSignal.Event.from(emitter)
	end

	return exported, exported
end
