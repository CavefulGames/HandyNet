--!optimize 2
--!native

local RunService = game:GetService("RunService")

local packetIDs = require(script.Parent.Parent.namespaces.packetIDs)
local readRefs = require(script.Parent.readRefs)
local emitter = require(script.Parent.Parent.emitter)

local ref = packetIDs.ref()
local runContext: "server" | "client" = if RunService:IsServer() then "server" else "client"

if runContext == "server" then
	return function(incomingBuffer: buffer, references: { [number]: unknown }?, player: Player?)
		local length = buffer.len(incomingBuffer)
		local readCursor = 0

		readRefs.set(references)

		while readCursor < length do
			local packet = ref[buffer.readu8(incomingBuffer, readCursor)]
			readCursor += 1

			local value, valueLength = packet.reader(incomingBuffer, readCursor)

			readCursor += valueLength

			emitter(packet.event, value, player)
		end
	end
elseif runContext == "client" then
	return function(incomingBuffer: buffer, references: { [number]: unknown }?, player: Player?)
		local length = buffer.len(incomingBuffer)
		local readCursor = 0

		readRefs.set(references)

		while readCursor < length do
			local packet = ref[buffer.readu8(incomingBuffer, readCursor)]
			readCursor += 1

			local value, valueLength = packet.reader(incomingBuffer, readCursor)

			readCursor += valueLength

			emitter(packet.event, value, player)
		end
	end
end
