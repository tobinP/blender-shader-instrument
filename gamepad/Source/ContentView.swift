//
//  ContentView.swift
//  Shared
//
//  Created by Sergey Romanenko on 09.12.2020.
//

import SwiftUI
import GameController

struct ContentView: View {
    var socketMan = SocketMan()
    let padMan: PadMan

    init() {
        padMan = PadMan(socketMan)
    }
    
    var body: some View {
        Spacer()
        Text("hey")
        Spacer()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
