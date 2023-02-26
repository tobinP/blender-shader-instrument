import websocket
import threading
import time
import rel


# if __name__ == "__main__":
def to_run():
    def on_message(ws, message):
        print(message)

    def on_error(ws, error):
        print(error)

    def on_close(ws, close_status_code, close_msg):
        print("### closed ###")

    def on_open(ws):
        print("Opened connection")
        
    websocket.enableTrace(True)
    ws = websocket.WebSocketApp("ws://localhost:8080",
                                on_open=on_open,
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)

    ws.run_forever(dispatcher=rel, reconnect=5)
    rel.signal(2, rel.abort)  # Keyboard Interrupt
    rel.dispatch()


new_thread = threading.Thread()
new_thread.run = to_run
new_thread.start()
    