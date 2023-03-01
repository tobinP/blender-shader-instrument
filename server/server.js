import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 8080 });

wss.on('connection', function connection(ws) {
	ws.on('message', function message(data) {
		let decoded = JSON.parse(data)
		console.log('received decoded: %s', decoded);
		wss.clients.forEach(function each(client) {
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

	let value = 0
	let shouldIncrease = true
	let incrementValue = 0.1
	const timer = setInterval(() => {
		console.log('value: %s', value);
		if (shouldIncrease) {
			value += incrementValue
			if (value > 10.9) {
				shouldIncrease = false
			}
		} else {
			value -= incrementValue
			if (value < 2.1) {
				shouldIncrease = true
			}
		}
		let obj = {
			name: "resize",
			xVal: value
		}
		ws.send(JSON.stringify(obj));
	}, 50)
});
