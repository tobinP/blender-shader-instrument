import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 8080 });

wss.on('connection', function connection(ws) {
	ws.on('message', function message(data) {
		let decoded = JSON.parse(data)
		console.log('received decoded: %s', decoded);
		wss.clients.forEach(function each(client) {
			console.log('client: %s', client._sender);
			if (client !== ws) {
				client.send(data);
			}
		});
	});
	let obj = { 
		name: "hello from server",
		xVal: 1 
	}
	ws.send(JSON.stringify(obj));
});
