//
//  main.swift
//  SocketPad
//
//  Created by tobin on 1/13/23.
//

import Foundation

print("Hello, World!")

let socketMan = SocketMan()
let padMan = PadMan(socketMan)

RunLoop.main.run()
//Thread.sleep(until: Date.distantFuture)
