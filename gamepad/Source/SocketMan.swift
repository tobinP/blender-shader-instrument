//
//  SocketMan.swift
//  SocketPad
//
//  Created by tobin on 1/30/23.
//

import Foundation
import SwiftUI

class SocketMan: NSObject, URLSessionWebSocketDelegate {
    private var webSocket : URLSessionWebSocketTask?
    private let encoder = JSONEncoder()

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

    func sendEvent(_ value: Data) {
        self.webSocket?.send(URLSessionWebSocketTask.Message.data(value), completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
    }

    func sendEvent(_ value: String) {
        self.webSocket?.send(URLSessionWebSocketTask.Message.string(value), completionHandler: { error in
            if let error = error {
                print(error)
            }
        })
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
//        self.receive()
//        self.send()
        do {
            let event = Event(name: "hello from swift", xVal: 0, yVal: 0, isPressed: false)
            let hello = try encoder.encode(event)
            self.sendEvent(hello)
        } catch {

        }
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        if let reason = reason {
            print("Disconnect from Server \(reason)")
        }
    }
}
