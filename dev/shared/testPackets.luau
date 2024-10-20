local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HandyNet = require(ReplicatedStorage.Packages.HandyNet)

return HandyNet.defineNamespace("game", function()
	return {
		myPacket = HandyNet.defineReliablePacket(
			HandyNet.array(HandyNet.boolean)
		),
	}
end)
