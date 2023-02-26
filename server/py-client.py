import asyncio
import threading
import websockets
import json

def outerTest():
	async def test():
		shouldRun = True
		async with websockets.connect('ws://localhost:8080') as websocket:
			hello = {
				"name": "hello from py client",
				"xVal": 2
			}
			await websocket.send(json.dumps(hello))
			while shouldRun:
				response = await websocket.recv()
				decoded = json.loads(response)
				print(decoded["name"])
				print(decoded["xVal"])
				if decoded["name"] == "quit":
					shouldRun = False
	loop = asyncio.new_event_loop()
	asyncio.set_event_loop(loop)
	asyncio.get_event_loop().run_until_complete(test())

new_thread = threading.Thread()
new_thread.run = outerTest
new_thread.start()

asyncio.get_event_loop().run_forever()
