--!strict
--!native
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local packets = require(ReplicatedStorage.shared.testPackets)

-- packets.myPacket.event:connect(function(data)
-- 	print("Confirming server -> client")
-- 	print(data)
-- end)

local part = Instance.new("Part")
part.Anchored = true
part.BrickColor = BrickColor.Red()
part.CFrame = CFrame.new(1, 1, 1)-- * CFrame.Angles(0.2, 0.4, 0.6)
part.Parent = workspace

-- packets.myPacket.send(part.CFrame)
packets.myPacket.send(Enum.KeyCode.A)

-- RunService.Heartbeat:Connect(function()
-- 	packets.myPacket.sendToServer("ez")
-- end)

local counter = require(ReplicatedStorage.shared.counter)

counter.countUp()
counter.countUp()
counter.countUp()
counter.countUp()
