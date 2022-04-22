//
//  Trip.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/12/22.
//

import Foundation
import SwiftUI
import CoreLocation


//class to store trips
class Trip: Codable, Identifiable, ObservableObject, Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.dest.id == rhs.dest.id
    }
    
    var id : UUID
    var dest : Destination
    var visits : [POI]
    
    init(dest : Destination, visits : [POI] = []) {
        self.dest = dest
        self.visits = Array(Set(visits))
        self.id = UUID()
    }
    
    //remove duplicate visits
    public func clean() {
        visits = Array(Set(visits))
        visits = sortByPriority(visits)
    }
    
    //sorts visits by priority
    func sortByPriority(_ visits: [POI]) -> [POI] {
        visits.sorted { a,b in
            a.priority > b.priority
        }
    }
    
    ///Remaining variables calculate center and radius of the trip
    ///Would ideally implement weighted trip center/radius depending on priority of visits
    
    var latDelta : Double {
        if visits.count == 1 {
            return 0.02
        }
        return min(2,(maxLat - minLat)*1.5)
    }
    
    var longDelta : Double {
        if visits.count == 1 {
            return 0.02
        }
        return min(2,(maxLong - minLong)*1.5)
    }
    
    var center : CLLocationCoordinate2D {
        if visits.count < 1 {
            return dest.locationCoordinate
        }
        var lat = 0.0
        var long = 0.0
        for visit in visits {
            lat += visit.locationCoordinate.latitude
            long += visit.locationCoordinate.longitude
        }
        return CLLocationCoordinate2D(latitude: lat/Double(visits.count), longitude: long/Double(visits.count))
    }

    var minLat : Double  {
        if visits.count < 1 {
            return 0
        }
        var tempMin = Double.greatestFiniteMagnitude
        for visit in visits {
            if visit.locationCoordinate.latitude < tempMin {
                tempMin = visit.locationCoordinate.latitude
            }
        }
        return tempMin
    }
    
    var maxLat : Double  {
        if visits.count < 1 {
            return 1
        }
        
        var tempMax = 0 - Double.greatestFiniteMagnitude
        for visit in visits {
            if visit.locationCoordinate.latitude > tempMax {
                tempMax = visit.locationCoordinate.latitude
            }
        }
        return tempMax
    }
    
    var minLong : Double  {
        if visits.count < 1 {
            return 0
        }
        var tempMin = Double.greatestFiniteMagnitude
        for visit in visits {
            if visit.locationCoordinate.longitude < tempMin {
                tempMin = visit.locationCoordinate.longitude
            }
        }
        return tempMin
    }
    
    var maxLong : Double  {
        if visits.count < 1 {
            return 1
        }
        var tempMax = 0 - Double.greatestFiniteMagnitude
        for visit in visits {
            if visit.locationCoordinate.longitude > tempMax {
                tempMax = visit.locationCoordinate.longitude
            }
        }
        return tempMax
    }
    

}
