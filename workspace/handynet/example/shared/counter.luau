local packets = require(script.Parent.testPackets)

local counts = {}

packets.events.countUp.connect(function(player: Player)
	local count = counts[player]
	if not count then
		count = 0
		counts[player] = count
	end

	count += 1
	counts[player] = count
end)

return {
	counts = counts,
	countUp = function()
		packets.events.countUp.fire()
	end
}
