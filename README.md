# [English](https://github.com/CavefulGames/HandyNet/blob/main/README_en.md) 👈
- [Example Usage](#example-usage)
- [TO-DOs](#to-dos-02x)

# 한국어

## HandyNet
더 Handy해진 [ByteNet](https://github.com/ffrostfall/ByteNet)의 포크

### 특징
- ByteNet의 포크이며 대부분의 구현을 공유합니다.
- 코드 설계 및 아이디어는 `kitty-utils/net`에서 파생되었습니다.

### 설치 (via pesde)
```sh
pesde add caveful_games/handynet
```

### ByteNet과 차이점
- (0.2.x 부터) `HandyNet.send`의 다이나믹 타입으로 인하여 이론적으로 서버에서의 `ByteNet.sendTo`과 `ByteNet.sendToAll`보다 조금 느릴 수 있습니다. (대신 심플하고 클라이언트에서 플레이어 인수를 사용하는 상황 제외 조금 더 타입에 안전하며 `Namespace.server`, `Namespace.client`가 필요없어졌습니다. -> 적어진 메모리 사용량)
- ~~HandyNet은 속도보다 메모리 사용량에 더 초점을 맞췄기 때문에 이론적으로 ByteNet이 더 빠를 수 있습니다. (ByteNet은 더 빠른 속도를 위해 페킷마다 메소드 함수를 생성하지만 HandyNet은 메타테이블을 활용하여 함수를 재활용합니다.)~~ 메모리 사용량이 그렇게 크지 않고 정적인 크기를 차지하므로 그대로 클로저를 사용합니다.
- `ByteNet.string` 자료형의 크기를 설정할 수 있습니다.
- `definePacket`의 인수 `reliablityType` 속성이 `defineReliablePacket`과 `defineUnreliablePacket` 두가지 함수로 나뉨에 따라 테이블 `props` 인수를 받지 않고 기존에 `value` 속성이었던 값 자료형만 단일 인수로 받습니다. (간소화)
- 몇가지 자료형 이름이 명확해졌습니다. (ex. `ByteNet.vec3` -> `HandyNet.Vector3`)
- ~~`Namespace` 타입에 `server`와 `client` 속성이 추가됨으로써 서버/클라이언트 구분을 더 명확히한 타입체킹이 가능합니다.~~
- ~~서버/클라이언트의 예측 및 동기화 모델, 어드민 커맨드를 만들 때 유용하게 사용될 수 있는 `Command`가 추가되었습니다.~~ (`event`로 대체됨)
- 이벤트 신호는 `LimeSignal`을 사용하여 받습니다. (결과적으로 Connection을 disconnect하기 더 간편해졌으며, 더 이상 `definePacket`에서 이벤트 신호 방식을 설정하지 않아도됩니다.)
- HandyNet은 타입스크립트 타입을 지원하지 않습니다.
- 쿼터니언을 사용하여 CFrame 역/직렬화 압축. (`HandyNet.RawCFrame`으로 `ByteNet.cframe`과 동일한 역/직렬화를 사용할 수 있습니다.)
- 더 많은 자료형 지원.

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
				enum = HandyNet.Enum.KeyCode
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
	if count then
		counts[player] += 1
	else
		counts[player] = 0
	end
end

packets.countUp.event:connect(countUp)

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

packets.countUp.event:connect(function()
	print("client has fired countUp event!")
end)
```

# Credits
- [ByteNet](https://github.com/ffrostfall/ByteNet) for original source codes. (licensed under MIT license)
- Special thanks to [Mark-Marks](https://github.com/Mark-Marks) for major feedbacks.

# TO-DOs (0.2.x)
- [x] Change `Packet.onServerReceived` and `Packet.onClientReceived` to `Packet.event`.
- [x] Change `HandyNet.defineReliablePacket` and `HandyNet.defineUnreliablePacket` to `HandyNet.definePacket` and provide reliability argument.
- [x] Replace `command`s with `event`s.
- [x] Remove `Namespace.client` and `Namespace.server`. `sendTo`, `sendToServer`, and `broadcast` are replaced by `send`.
- [x] `Packet`s are now one directional.
- [x] Add `BrickColor` and `Enum` data type.
- [x] Update README.md.
- [ ] Test 0.2.0
- [ ] Release and publish into pesde.
- [ ] (maybe 0.2.1?) Add korean(한국어) translated comments.
