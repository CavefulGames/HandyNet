local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HandyNet = require(ReplicatedStorage.Packages.HandyNet)

return HandyNet.defineNamespace("game", function()
	return {
		myPacket = HandyNet.definePacket(
			"client->server",
			HandyNet.CFrame
		),
		countUp = HandyNet.defineEvent()
	}
end)
