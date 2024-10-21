local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HandyNet = require(ReplicatedStorage.Packages.HandyNet.lib)

return HandyNet.defineNamespace("game", function()
	return {
		myPacket = HandyNet.defineReliablePacket(
			HandyNet.string(2)
		),
		helloCommand = HandyNet.defineReliableCommand(function()
			print("Merhaba!")
		end)
	}
end)
