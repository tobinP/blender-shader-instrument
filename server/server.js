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

	// autoRun("resize", 2, 10, 0.1)
	autoRun("twist", -6.2, 6.2, 0.1)

	function autoRun(event, min, max, incrementValue) {
		let value = 0
		let shouldIncrease = true
		const timer = setInterval(() => {
			console.log('value: %s', value);
			if (shouldIncrease) {
				value += incrementValue
				if (value > max) {
					shouldIncrease = false
				}
			} else {
				value -= incrementValue
				if (value < min) {
					shouldIncrease = true
				}
			}
			let obj = {
				name: event,
				xVal: value
			}
			ws.send(JSON.stringify(obj));
		}, 50)
	}
});
