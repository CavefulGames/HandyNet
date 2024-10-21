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

	local part = Instance.new("Part")
	part.Anchored = true
	part.BrickColor = BrickColor.Blue()
	part.CFrame = data
	part.Parent = workspace
end)

-- RunService.Heartbeat:Connect(function()
-- 	packets.myPacket.broadcast("aa")
-- end)

task.wait(5)
packets.helloCommand()
