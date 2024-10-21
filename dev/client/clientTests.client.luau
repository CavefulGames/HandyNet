--!strict
--!native
--!optimize 2

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local packets = require(ReplicatedStorage.shared.testPackets).client

packets.myPacket.onClientReceived:connect(function(data)
	print("Confirming server -> client")
	print(data)
end)

local part = Instance.new("Part")
part.Anchored = true
part.BrickColor = BrickColor.Red()
part.CFrame = CFrame.new(1, 1, 1)-- * CFrame.Angles(0.2, 0.4, 0.6)
part.Parent = workspace

packets.myPacket.sendToServer(part.CFrame)

-- RunService.Heartbeat:Connect(function()
-- 	packets.myPacket.sendToServer("ez")
-- end)

packets.helloCommand()
