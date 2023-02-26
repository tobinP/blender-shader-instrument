import socket
import time
import sys
HOST = '127.0.0.1'
PORT = 8080

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))

s.listen()
print("test 0")
conn, addr = s.accept()
print("test 1")
conn.settimeout(0.0)

def handle_data():
	shouldRun = True
	print("start of handle_data")
	while shouldRun:
		time.sleep(0.1)
		data = None

		# In non-blocking mode blocking operations error out with OS specific errors.
		# https://docs.python.org/3/library/socket.html#notes-on-socket-timeouts
		try:
			data = conn.recv(1024)
		except:
			pass

		if not data:
			pass
		else:
			conn.sendall(data)

			if "cube" in data.decode("utf-8"):
				print("cube message received")

			if "quit" in data.decode("utf-8"):
				print("quit message received")
				shouldRun = False
				conn.close()
				s.close()
print("test 2")
handle_data()