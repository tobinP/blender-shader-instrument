//
//  ViewController.swift
//  WebSocket-Tutorial
//
//  Created by omair khan on 05/01/2022.
//

import UIKit

class ViewController: UIViewController,URLSessionWebSocketDelegate {
    let button : UIButton = {
        var btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("Disconnect", for: .normal)
        return btn
    }()
    
    private var webSocket : URLSessionWebSocketTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        button.frame = CGRect(x: self.view.frame.width/2 - 100, y: self.view.frame.width/2, width: 200, height: 100)
        self.view.addSubview(button)
        self.view.backgroundColor = .blue
        button.addTarget(self, action: #selector(closeSession), for: .touchUpInside)
        
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
    
    func send(){
        let workItem = DispatchWorkItem{
            self.webSocket?.send(URLSessionWebSocketTask.Message.string("Hello from swift"), completionHandler: { error in
                if error == nil {
                    self.send()
                }else{
                    print(error!)
                }
            })
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: workItem)
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

