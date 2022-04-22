//
//  POI.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/11/22.
//

import Foundation
import MapKit

//stuct to store places of interest
struct POI: Hashable, Identifiable, Codable {

    
    var id = UUID()
    var name : String
    var category : String
    var priority : Int
    var subtitle : String
    
    init(name: String = "", subtitle: String = "", id: UUID = UUID(), category:String = "", coordinates: Coordinates, priority: Int = 1){
        self.name = name
        self.id = id
        self.category = category
        self.coordinates = coordinates
        self.priority = priority
        self.subtitle = subtitle
    }
    
    init(){
        self.name = ""
        self.id = UUID()
        self.category = "OTHER"
        self.coordinates = Coordinates(latitude: 0, longitude: 0)
        self.priority = 0
        self.subtitle = ""
    }
    
    private var coordinates: Coordinates
    
    var locationCoordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

}
