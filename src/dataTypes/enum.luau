local types = require(script.Parent.Parent.types)
local bufferWriter = require(script.Parent.Parent.process.bufferWriter)

local writeu16 = bufferWriter.writeu16
local rwCache = {}

return setmetatable({}, {
	__index = function(_, key: string): types.dataTypeInterface<EnumItem>
		local enum = (Enum :: { [any]: any })[key] :: Enum
		local items: { EnumItem } = enum:GetEnumItems()

		local rw = rwCache[key]
		if rw then
			return rw
		end

		rw = {
			read = function(b: buffer, cursor: number)
				local item
				local value = buffer.readu16(b, cursor)
				for _,v in items do
					if v.Value == value then
						item = v
						break
					end
				end
				return item
			end,
			write = function(data: EnumItem)
				writeu16(data.Value)
			end
		}

		rwCache[key] = rw

		return rw
	end
})
