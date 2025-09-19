local bufferWriter = require(script.Parent.Parent.process.bufferWriter)
local types = require(script.Parent.Parent.types)

local writeu16 = bufferWriter.writeu16
local writecopy = bufferWriter.writecopy
local dyn_alloc = bufferWriter.dyn_alloc
local rwCache = {}
local defaultBuffRW = {
	read = function(b: buffer, cursor: number)
		local length = buffer.readu16(b, cursor)
		local freshBuffer = buffer.create(length)

		-- copy the data from the main buffer to the new buffer with an offset of 2 because of length
		buffer.copy(freshBuffer, 0, b, cursor + 2, length)

		return freshBuffer, length + 2
	end,
	write = function(data: buffer)
		local length = buffer.len(data)
		writeu16(length)

		dyn_alloc(length)

		-- write the length of the buffer, then the buffer itself
		writecopy(data)
	end,
}

return function(size: (types.dataTypeInterface<number> | number)?): types.dataTypeInterface<buffer>
	local rw = rwCache[size]
	if rw then
		return rw
	end

	if size == nil then
		return defaultBuffRW
	elseif type(size) == "number" then
		rw = {
			read = function(b: buffer, cursor: number)
				local freshBuffer = buffer.create(size)

				buffer.copy(freshBuffer, 0, b, cursor, size)

				return freshBuffer, size
			end,
			write = function(data: buffer)
				writeu16(size)

				dyn_alloc(size)

				writecopy(data)
			end
		}
	else
		rw = {
			read = function(b: buffer, cursor: number)
				local length, written = size.read(b, cursor)

				local freshBuffer = buffer.create(length)

				buffer.copy(freshBuffer, 0, b, cursor + written, length)

				return freshBuffer, length + written
			end,
			write = function(data: buffer)
				local length = buffer.len(data)
				size.write(length)

				dyn_alloc(length)

				writecopy(data)
			end
		}
	end

	-- caches read & writer
	rwCache[size] = rw

	return rw
end
