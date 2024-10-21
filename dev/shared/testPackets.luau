local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HandyNet = require(ReplicatedStorage.Packages.HandyNet.lib)

return HandyNet.defineNamespace("game", function()
	return {
		myPacket = HandyNet.defineReliablePacket(
			HandyNet.string(HandyNet.u8)
		),
	}
end)
