[한국어](https://github.com/CavefulGames/HandyNet/blob/main/README_kr.md) 👈
# English

## HandyNet
[ByteNet](https://github.com/ffrostfall/ByteNet) fork made more handy

### About
- HandyNet is a fork of ByteNet and shares most of its implementation.
- The code design and ideas are derived from `kitty-utils/net`.

### Installation (via pesde)
```sh
pesde add caveful_games/handynet
```

### Differences from ByteNet
- (From `v0.2.0`) Due to the dynamic typing of `HandyNet.send`, it can theoretically be slightly slower than `ByteNet.sendTo` and `ByteNet.sendToAll` on the server. (It is more simple and more type-safe and removes the need for `Namespace.server` and `Namespace.client`, except in cases where the player argument is used on the client.)
- (From `v0.2.0`) `Packet`s are one directional.
- (From `v0.2.1`) Packet definitions can be nested for labeling purpose.
- Resizable `ByteNet.string` data type.
- Simplified `definePacket` API.
- Some data type names have been made clearer.
- ~~Added `Command`, which is handier for designing a client/server synchronization model.~~ (Replaced by `event`s)
- Events and connections are handled by `LimeSignal` which is fork of `LemonSignal`. (Simple event handling method)
- HandyNet does not support TypeScript.
- New serdes for `CFrame`.
- New data types: `RawCFrame`(equal to `ByteNet.cframe`), `CFrame`(uses Quaternion to compress into 13~19 bytes), `AlignedCFrame`, `UnalignedCFrame`, `Enum`, and `BrickColor`

# Example Usage
```lua
-- packets.luau

return HandyNet.defineNamespace("example", function()
	return {
		hello = HandyNet.definePacket(
			"client->server",
			HandyNet.struct({
				message = HandyNet.string(HandyNet.u8), -- Customizable string size (defaults to u16)
				cf = HandyNet.CFrame, -- Uses quaternion to compress!
				enum = HandyNet.Enum.KeyCode :: Enum.KeyCode -- Weird type error with enums..
			})
			-- default: "reliable"
		),
		countUp = HandyNet.defineEvent("unreliable")
  	}
end)
```

```lua
-- shared.luau

local packets = require(path.to.packets)

local counts = {}

local function countUp(player)
	local count = counts[player]
	if not count then
		count = 0
		counts[player] = count
	end

	count += 1
	counts[player] = count

	print("count:", count)
end

packets.countUp.connect(countUp)

return {}
```

```lua
-- client.luau

local packets = require(path.to.packets)

packets.hello.send({
	message = "hi ya",
	cf = CFrame.new(),
	enum = Enum.KeyCode.X
})

packets.countUp.fire()
```

```lua
-- server.luau

local packets = require(path.to.packets)

-- packets.some.send(data, player)
-- if you want 'sendToAll': packets.some.send(data)

packets.hello.event:connect(function()
	print("received hello from client")
end)

packets.countUp.connect(function()
	print("client has fired countUp event!")
end)
```

# Credits
- [ByteNet](https://github.com/ffrostfall/ByteNet) for original source codes. (licensed under MIT license)
- Special thanks to [Mark-Marks](https://github.com/Mark-Marks) for major feedbacks.
- Special thanks to roasted_shrimps for new CFrame serdes idea.

# TO-DOs

## `v0.2.2`
- [x] Make README.md english as default.
- [x] Publish to pesde to take effect with newer README.md.

## `v0.2.3`
- [x] Fix dependencies require error.
