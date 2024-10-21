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

-- RunService.Heartbeat:Connect(function()
-- 	packets.myPacket.sendToServer("ez")
-- end)

packets.helloCommand()
