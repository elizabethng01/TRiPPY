//
//  TRiPPYApp.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/8/22.
//

import SwiftUI

@main
struct TRiPPYApp: App {
    @StateObject var modelData = ModelData()
    @ObservedObject var monitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            ZStack {
                //will show alert on any view if no network connection
                ContentView().environmentObject(modelData)
                    .alert(isPresented:$monitor.isNotConnected, content: {
                        Alert(title: Text("No network connection"), dismissButton: .destructive(Text("OK")))
                    })

            }
        }
    }
}
