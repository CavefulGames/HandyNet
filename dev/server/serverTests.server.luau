--!strict
--!native
--!optimize 2

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local packets = require(ReplicatedStorage.shared.testPackets).server

packets.myPacket.onServerReceived:connect(function(data, player)
	print("Confirming client -> server")
	print(data)
end)

RunService.Heartbeat:Connect(function()
	packets.myPacket.broadcast("aa")
end)

task.wait(5)
packets.helloCommand()
