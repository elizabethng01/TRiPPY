//
//  NetworkMonitor.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/15/22.
//

//https://morioh.com/p/68816b37881c
//NETWORK MONITOR: This class checks if the user is connected to the internet

import Foundation
import Network
 
final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
     
    @Published var isNotConnected = false
     
    init() {
        monitor.pathUpdateHandler =  { [weak self] path in
            DispatchQueue.main.async {
                self?.isNotConnected = path.status == .satisfied ? false : true
            }
        }
        monitor.start(queue: queue)
    }
}
