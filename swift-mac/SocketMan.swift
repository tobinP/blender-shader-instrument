//
//  SocketMan.swift
//  SocketPad
//
//  Created by tobin on 1/30/23.
//

import Foundation

class SocketMan: NSObject, URLSessionWebSocketDelegate {
    private var webSocket : URLSessionWebSocketTask?

    override init() {
        super.init()
        startSession()
    }

    private func startSession() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "ws://localhost:8080")
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
    }

    func receive(){
        let workItem = DispatchWorkItem{ [weak self] in
            self?.webSocket?.receive(completionHandler: { result in
                switch result {
                case .success(let message):
                    switch message {
                    case .data(let data):
                        print("Data received \(data)")
                    case .string(let strMessgae):
                        print("String received \(strMessgae)")
                    default:
                        break
                    }
                case .failure(let error):
                    print("Error Receiving \(error)")
                }
                self?.receive()
            })
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 1 , execute: workItem)
    }

    func sendRepeat(){
        let workItem = DispatchWorkItem{
            self.webSocket?.send(URLSessionWebSocketTask.Message.string("repeat from mac app"), completionHandler: { error in
                if let error = error {
                    print(error)
                }
                self.send()
            })
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: workItem)
    }

    func send(){
        self.webSocket?.send(URLSessionWebSocketTask.Message.string("Hello from mac app"), completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }

    @objc func closeSession(){
        webSocket?.cancel(with: .goingAway, reason: "You've Closed The Connection".data(using: .utf8))
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
        self.receive()
        self.send()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        if let reason = reason {
            print("Disconnect from Server \(reason)")
        }
    }
}
