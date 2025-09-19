local bufferWriter = require(script.Parent.Parent.process.bufferWriter)
local types = require(script.Parent.Parent.types)

local writeu16 = bufferWriter.writeu16
local writestring = bufferWriter.writestring
local dyn_alloc = bufferWriter.dyn_alloc
local rwCache = {}
local defaultStringRW = {
	-- 2 bytes for the length, then the string
	read = function(b: buffer, cursor: number)
		local length = buffer.readu16(b, cursor)

		return buffer.readstring(b, cursor + 2, length), length + 2
	end,
	write = function(data: string)
		local length = #data
		writeu16(length)

		dyn_alloc(length)
		writestring(data)
	end,
}

return function(size: (types.dataTypeInterface<number> | number)?): types.dataTypeInterface<string>
	local rw = rwCache[size]
	if rw then
		return rw
	end

	if size == nil then
		return defaultStringRW
	elseif type(size) == "number" then
		rw = {
			read = function(b: buffer, cursor: number)
				return buffer.readstring(b, cursor, size), size
			end,
			write = function(data: string)
				dyn_alloc(size)
				writestring(data)
			end
		}
	else
		rw = {
			read = function(b: buffer, cursor: number)
				local length, written = size.read(b, cursor)

				return buffer.readstring(b, cursor + written, length), length + written
			end,
			write = function(data: string)
				local length = #data
				size.write(length)

				dyn_alloc(length)
				writestring(data)
			end
		}
	end

	-- caches read & writer
	rwCache[size] = rw

	return rw
end
