local ReplicatedStorage = game:GetService("ReplicatedStorage")

local HandyNet = require(ReplicatedStorage.Packages.HandyNet)

return HandyNet.defineNamespace("game", function()
	return {
		myPacket = HandyNet.defineReliablePacket(
			HandyNet.AlignedCFrame
		),
		helloCommand = HandyNet.defineReliableCommand(function()
			print("Merhaba!")
		end)
	}
end)
