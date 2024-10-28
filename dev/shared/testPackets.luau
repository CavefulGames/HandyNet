local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HandyNet = require(ReplicatedStorage.HandyNet)

return HandyNet.defineNamespace("game", {
	myPacket = HandyNet.definePacket(
		"client->server",
		HandyNet.CFrame
		-- HandyNet.Enum.KeyCode :: Enum.KeyCode
	),
	events = {
		countUp = HandyNet.defineEvent()
	}
})
