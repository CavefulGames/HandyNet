local types = require(script.Parent.Parent.types)
local bufferWriter = require(script.Parent.Parent.process.bufferWriter)

local writeu32 = bufferWriter.writeu32
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
				local value = buffer.readu32(b, cursor)
				for _,v in items do
					if v.Value == value then
						item = v
						break
					end
				end
				return item, 4
			end,
			write = function(data: EnumItem)
				writeu32(data.Value)
			end
		}

		rwCache[key] = rw

		return rw
	end
})
