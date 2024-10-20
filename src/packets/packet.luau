--!native
--!optimize 2
local Players = game:GetService("Players")
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

	-- RunContext error checking that doesn't have performance drawbacks
	-- setmetatable(exported, {
	-- 	__index = function(index)
	-- 		if
	-- 			(index == "sendTo" or index == "sendToAllExcept" or index == "sendToAll")
	-- 			and moduleRunContext == "client"
	-- 		then
	-- 			error("You cannot use sendTo, sendToAllExcept, or sendToAll on the client")
	-- 		elseif index == "send" and moduleRunContext == "server" then
	-- 			error("You cannot use send on the server")
	-- 		end
	-- 	end,
	-- })

	-- exposed for the reader file
	exported.reader = value.read

	if moduleRunContext == "server" then
		-- function exported.sendToList(data, players: { Player })
		-- 	for _, player in players do
		-- 		serverSendFunction(player, id, writer, data)
		-- 	end
		-- end

		function exported.sendTo(data, player: Player)
			serverSendFunction(player, id, writer, data)
		end

		-- function exported.sendToAllExcept(data, except: Player)
		-- 	for _, player: Player in Players:GetPlayers() do
		-- 		if player ~= except then
		-- 			serverSendFunction(player, id, writer, data)
		-- 		end
		-- 	end
		-- end

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

	return exported
end
