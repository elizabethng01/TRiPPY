//
//  ModelData.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/11/22.
//

import Foundation
import SwiftUI

class ModelData: ObservableObject {
    
    @Published var trips : [Trip]

    //DEFAULT DESTINATIONS
    let melbourne = Trip(dest: Destination(name: "Melbourne", state: "VIC", id: UUID(), country: "Australia", coordinates: Coordinates(latitude: -37.815031, longitude: 144.966347)),
                         visits: [POI(name: "Lona Misa", subtitle: "234 Toorak Rd, South Yarra VIC 3141", id: UUID(), category: Category.food.rawValue, coordinates: Coordinates(latitude: -37.839531, longitude: 144.994891), priority: 5),
                                  POI(name: "Queen Victoria Market", subtitle:"Corner of Elizabeth & Victoria Streets, Melbourne VIC 3000", id: UUID(), category: Category.shopping.rawValue, coordinates: Coordinates(latitude: -37.807677,longitude: 144.957693), priority: 5),
                                  POI(name: "Emporium", subtitle: "287 Lonsdale St, Melbourne VIC 3000", id: UUID(), category: Category.shopping.rawValue, coordinates: Coordinates(latitude: -37.812458, longitude: 144.963859), priority: 3),
                                  POI(name: "NGV", subtitle: "180 St Kilda Road Melbourne VIC 3006", id: UUID(), category: Category.attraction.rawValue, coordinates: Coordinates(latitude: -37.822709 ,longitude: 144.968988), priority: 3)
                         ])
    let chicago = Trip(dest: Destination(name: "Chicago", state: "IL", id: UUID(), country: "United States", coordinates: Coordinates(latitude: 41.866242, longitude: -87.623653)),
                       visits: [POI(name: "Soldier Field", subtitle: "1410 S Museum Campus Dr Chicago, IL 60605", id: UUID(), category: Category.attraction.rawValue, coordinates: Coordinates(latitude: 41.862302, longitude:-87.616702), priority: 5),
                                POI(name: "Devil Dawgs", subtitle: "767 S State St Chicago, IL 60605", id: UUID(), category: Category.food.rawValue, coordinates: Coordinates(latitude: 41.872117,longitude:  -87.627318), priority: 4),
                                POI(name: "Willis Tower", subtitle: "233 S Wacker Dr Chicago, IL 60606", id: UUID(), category: Category.other.rawValue, coordinates: Coordinates(latitude: 41.878829, longitude: -87.636156), priority: 4),
                                POI(name: "The Bean", subtitle: "201 E Randolph St Chicago, IL 60602", id: UUID(), category: Category.attraction.rawValue, coordinates: Coordinates(latitude: 41.882678,longitude: -87.623327), priority: 3),
                                POI(name: "Navy Pier", subtitle: "600 E Grand Ave Chicago, IL 60611", id: UUID(), category: Category.attraction.rawValue, coordinates: Coordinates(latitude: 41.891815, longitude: -87.604240), priority: 2)
                       ])
    
    var defaultTrips : [Trip]
    
    init() {
        self.defaultTrips = [melbourne,chicago]
        self.trips = [melbourne,chicago]
        if let data = UserDefaults.standard.data(forKey: "Trips"){
            if let decoded = try? JSONDecoder().decode([Trip].self,from:data){
                self.trips = decoded
            }
        }
        if let data = UserDefaults.standard.data(forKey: "Default Trips"){
            if let decoded = try? JSONDecoder().decode([Trip].self,from:data){
                self.defaultTrips = decoded
            }
        }
    }
    
    //Save trips to user defaults
    func save() {
        if let encoded = try? JSONEncoder().encode(trips) {
            UserDefaults.standard.set(encoded, forKey: "Trips")
        }
        if let encoded = try? JSONEncoder().encode(defaultTrips) {
            UserDefaults.standard.set(encoded, forKey: "Default Trips")
        }
    }
    
    func update() {
        for trip in trips {
            trip.clean()
        }
        save()
    }
}
