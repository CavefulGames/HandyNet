--!native
--!optimize 2

local event = require(script.Parent.event)

return function(reliability: string?)
	reliability = reliability or "reliable"
	if reliability ~= "reliable" and reliability ~= "unreliable" then
		error("Argument 'reliability' must be 'reliable' or 'unreliable'")
	end

	return function(id: number)
		return event(reliability == "reliable", id)
	end
end
