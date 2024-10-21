<h1 align="center">English</h1>

# HandyNet
[ByteNet](https://github.com/ffrostfall/ByteNet) fork made more handy

<h1 align="center">한국어</h1>

# HandyNet
더 Handy해진 [ByteNet](https://github.com/ffrostfall/ByteNet)의 포크

## 특징
- ByteNet의 포크이며 대부분의 구현을 공유합니다.
- 코드 설계 및 아이디어는 `kitty-utils/net`에서 파생되었습니다.

## ByteNet과 차이점
- ~~HandyNet은 속도보다 메모리 사용량에 더 초점을 맞췄기 때문에 이론적으로 ByteNet이 더 빠를 수 있습니다. (ByteNet은 더 빠른 속도를 위해 페킷마다 메소드 함수를 생성하지만 HandyNet은 메타테이블을 활용하여 함수를 재활용합니다.)~~ 메모리 사용량이 그렇게 크지 않고 정적인 크기를 차지하므로 그대로 클로저를 사용합니다.
- `ByteNet.string` 자료형의 크기를 설정할 수 있습니다.
- `definePacket`의 인수 `reliablityType` 속성이 `defineReliablePacket`과 `defineUnreliablePacket` 두가지 함수로 나뉨에 따라 테이블 `props` 인수를 받지 않고 기존에 `value` 속성이었던 값 자료형만 단일 인수로 받습니다. (간소화)
- 몇가지 자료형 이름이 명확해졌습니다. (ex. `ByteNet.vec3` -> `HandyNet.Vector3`)
- `Namespace` 타입에 `server`와 `client` 속성이 추가됨으로써 서버/클라이언트 구분을 더 명확히한 타입체킹이 가능합니다.
- 서버/클라이언트의 예측 및 동기화 모델, 어드민 커맨드를 만들 때 유용하게 사용될 수 있는 `Command`가 추가되었습니다.
- 이벤트 신호는 `LimeSignal`을 사용하여 받습니다. (결과적으로 Connection을 disconnect하기 더 간편해졌으며, 더 이상 `definePacket`에서 이벤트 신호 방식을 설정하지 않아도됩니다.)
- HandyNet은 타입스크립트 타입을 지원하지 않습니다.

## 사용 예제
```lua
-- packets.luau

return HandyNet.defineNamespace("example", function()
	return {
		hello = HandyNet.defineReliablePacket(
			HandyNet.struct({
				message = HandyNet.string(HandyNet.u8), -- Customizable string size (defaults to u16)
				cf = HandyNet.CFrame
			})
		),
		command = HandyNet.defineReliableCommand(function()
			print("You ran the function in the server and the client!")
		end)
  	}
end)
```

```lua
-- client.luau

local packets = require(path.to.packets).client

packets.hello.sendToServer({
	message = "hi ya",
	cf = CFrame.new()
})

packets.hello.onClientReceived:connect(function()
	print("received hello from server")
end)

packets.command()
```

```lua
-- server.luau

local packets = require(path.to.packets).server

packets.hello.sendTo(player, {
	message = "hi ya",
	cf = CFrame.new()
})

packets.hello.onServerReceived:connect(function()
	print("received hello from client")
end)

packets.command()
```

# TO-DOs
- [ ] Complete english part of `README.md`.
- [ ] Publish to `pesde`.
- [x] Simplify `definePacket` arguments. (remove props and replace to `defineReliablePacket` and `defineUnreliablePacket`)
- [x] Bind events using `LimeSignal`.
- [x] Add optional size argument for `string` datatype.
- [ ] Add optional size argument for `buff` datatype like `string` datatype.
- [x] Cache `string` datatype's read & writer for reusing.
- [x] Clarify the datatype names.
- [x] Add more strict typechecking for client/server.
- [x] Set repository language to Luau.
- [ ] Add new `CFrame` serdes.
- [ ] Implement `defineReliableCommand` and `defineUnreliableCommand`.
