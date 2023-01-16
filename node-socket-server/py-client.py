import asyncio
import threading
import websockets


def outerTest():
	async def test():
		shouldRun = True
		async with websockets.connect('ws://localhost:8080') as websocket:
			await websocket.send("hello")
			while shouldRun:
				response = await websocket.recv()
				if response == "from server: quit":
					shouldRun = False
				print(response)
	loop = asyncio.new_event_loop()
	asyncio.set_event_loop(loop)
	asyncio.get_event_loop().run_until_complete(test())

new_thread = threading.Thread()
new_thread.run = outerTest
new_thread.start()

asyncio.get_event_loop().run_forever()