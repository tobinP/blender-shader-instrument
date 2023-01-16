import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 8080 });

wss.on('connection', function connection(ws) {
	ws.on('message', function message(data) {
		console.log('received1: %s', data);
		wss.clients.forEach(function each(client) {
			// if (client !== ws && client.readyState === WebSocket.OPEN) {
				client.send(`from server: ${data}`);
			// }
		});
	});

	ws.send('from server: hello');
});
