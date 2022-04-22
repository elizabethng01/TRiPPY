//
//  Coordinates.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/12/22.
//

import Foundation
import CoreLocation

struct Coordinates: Hashable, Codable{
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ clCoord : CLLocationCoordinate2D){
        self.latitude = clCoord.latitude
        self.longitude = clCoord.longitude
    }
}
