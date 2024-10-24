--!native
--!optimize 2

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local client = require(script.Parent.Parent.process.client)
local server = require(script.Parent.Parent.process.server)
local LimeSignal = require(script.Parent.Parent.Parent.limesignal)
local emitter = require(script.Parent.Parent.emitter)
local nothing = require(script.Parent.Parent.dataTypes.nothing)()

local moduleRunContext: "server" | "client" = if RunService:IsServer() then "server" else "client"

return function(reliable: boolean, id: number)
	local exported = {}

	if moduleRunContext == "server" then
		local serverSendFunction: (player: Player, id: number, writer: (value: any) -> (), data: any) -> () = if reliable
			then server.sendPlayerReliable
			else server.sendPlayerUnreliable

		local serverSendAllFunction: (id: number, writer: (value: any) -> (), data: any) -> () = if reliable
			then server.sendAllReliable
			else server.sendAllUnreliable

		local event = LimeSignal.Event.from(emitter) :: LimeSignal.Event<nil, Player>
		exported.reader = nothing.read
		exported.event = event

		function exported.connect(fn)
			return event:connect(function(_, player)
				fn(player)
			end)
		end

		function exported.fire(player: Player?)
			if player then
				serverSendFunction(player, id, nothing.write)
				emitter(event, nil, player)
			else
				serverSendAllFunction(id, nothing.write)
				for _, plr in Players:GetPlayers() do
					emitter(event, nil, plr)
				end
			end
		end
	elseif moduleRunContext == "client" then
		local localPlayer = Players.LocalPlayer

		local clientSendFunction: (id: number, writer: (value: any) -> (), data: any) -> () = if reliable
			then client.sendReliable
			else client.sendUnreliable

		local event = LimeSignal.Event.from(emitter) :: LimeSignal.Event<nil, Player>
		exported.reader = nothing.read
		exported.event = event

		function exported.connect(fn)
			return event:connect(function()
				fn(localPlayer)
			end)
		end

		function exported.fire()
			clientSendFunction(id, nothing.write)
			emitter(event, nil, localPlayer)
		end
	end

	return exported
end
