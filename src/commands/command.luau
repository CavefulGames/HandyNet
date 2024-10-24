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

local COMMAND_HANDLE_ERROR = "This command is already initialized and being handled"

return function(id: number)
	local reliable = true -- No unreilable setting supported. because commands should be reliable for better synced state
	local command
	local exported = {}

	if moduleRunContext == "server" then
		local serverSendFunction: (player: Player, id: number, writer: (value: any) -> (), data: any) -> () = if reliable
			then server.sendPlayerReliable
			else server.sendPlayerUnreliable

		local serverSendAllFunction: (id: number, writer: (value: any) -> (), data: any) -> () = if reliable
			then server.sendAllReliable
			else server.sendAllUnreliable

		local event = LimeSignal.Event.from(emitter)
		exported.reader = nothing.read
		exported.event = event

		local handle
		command = function(fn: (Player) -> ())
			if handle then
				error(COMMAND_HANDLE_ERROR)
			end
			handle = fn
			event:connect(fn)
			return function(player: Player)
				if player then
					handle(player)
					serverSendFunction(player, id, nothing.write, nil)
				else
					for _, plr in Players:GetPlayers() do
						handle(plr)
					end
					serverSendAllFunction(id, nothing.write, nil)
				end
			end
		end
	elseif moduleRunContext == "client" then
		local localPlayer = Players.LocalPlayer

		local clientSendFunction: (id: number, writer: (value: any) -> (), data: any) -> () = if reliable
			then client.sendReliable
			else client.sendUnreliable

		local event = LimeSignal.Event.from(emitter)
		exported.reader = nothing.read
		exported.event = event

		local handle
		command = function(fn: (Player) -> ())
			if handle then
				error(COMMAND_HANDLE_ERROR)
			end
			handle = fn
			event:connect(fn)
			return function()
				handle(localPlayer)
				clientSendFunction(id, nothing.write, nil)
			end
		end
	end

	return exported, command
end
