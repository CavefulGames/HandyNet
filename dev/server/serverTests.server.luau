--!strict
--!native
--!optimize 2

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local packets = require(ReplicatedStorage.shared.testPackets)

-- packets.myPacket.event:connect(function(data, player)
-- 	print("Confirming client -> server")
-- 	print(data)

-- 	local part = Instance.new("Part")
-- 	part.Anchored = true
-- 	part.BrickColor = BrickColor.Blue()
-- 	part.CFrame = data
-- 	part.Parent = workspace
-- end)

packets.myPacket.event:connect(function(data)
	print("received enum:", data)
end)

-- RunService.Heartbeat:Connect(function()
-- 	packets.myPacket.broadcast("aa")
-- end)

local counter = require(ReplicatedStorage.shared.counter)

Players.PlayerAdded:Connect(function()
	counter.countUp()
end)

packets.events.countUp.connect(function(player)
	print("count in server:", counter.counts[player])
end)
