//
//  Destination.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/9/22.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit


//struct to store Destinatinos
struct Destination: Hashable, Codable, Identifiable {
    
    var id: UUID
    var name: String
    var state: String
    var country: String

    init(name: String = "", state: String = "", id: UUID = UUID(), country:String = "", coordinates: Coordinates){
        self.name = name
        self.state = state
        self.id = id
        self.country = country
        self.coordinates = coordinates
    }

    private var coordinates: Coordinates
    
    var locationCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
}


