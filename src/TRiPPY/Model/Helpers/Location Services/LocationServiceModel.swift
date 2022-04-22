//
//  ContentViewModel.swift
//  AppleLocalSearch
//
//  Created by Robin Kment on 13.10.2020.
//
//https://kment-robin.medium.com/swiftui-location-search-with-mapkit-c64589990a66
//LOCATION SERVICE MODEL: This class uses the Location Service class to conduct a search and stores each result as a LocationServiceData object

import Foundation
import MapKit
import Combine
import SwiftUI

struct LocationServiceData: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var coordinate : CLLocationCoordinate2D
    var country : String
    var state : String {
        var components = subtitle.components(separatedBy:", ")
        components.removeLast()
        if let lastEl = components.last {
            var stateZip = lastEl.components(separatedBy: " ")
            stateZip.removeLast()

            if let state = stateZip.last {
                return state
            }
        }
        return ""
    }
    var marker : MapAnnotation<AnnotationView>

    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
        self.coordinate = mapItem.placemark.coordinate
        let locale = NSLocale.current
        self.country = locale.localizedString(forRegionCode: mapItem.placemark.countryCode ?? "") ?? ""
        self.marker = MapAnnotation(coordinate: coordinate, content: {
            AnnotationView(name: "", hotel: true)
        })
    }
    
    //create LocationServiceData object from POI
    init(poi : POI){
        self.title = poi.name
        self.subtitle = poi.subtitle
        self.coordinate = poi.locationCoordinate
        self.country = ""
        self.marker = MapAnnotation(coordinate: coordinate, content: {
            AnnotationView(name: poi.name,hotel: false)
        })
    }
    
    func distance(center: CLLocationCoordinate2D) -> Double {
        return (pow(self.coordinate.latitude - center.latitude,2) + pow(self.coordinate.longitude - center.longitude,2)).squareRoot()
    }
    
    func rating(center : CLLocationCoordinate2D) -> Int {
        var rating = 1
        if distance(center: center) < 0.005{
            rating = 3
        }
        else if distance(center:center) < 0.01 {
            rating = 2
        }
        return rating
    }
}

//Conducts location search using LocationService
final class LocationServiceModel: ObservableObject {
    private var cancellable: AnyCancellable?

    @Published var cityText = "" {
        didSet {
            searchForCity(text: cityText)
        }
    }
    
    @Published var poiText = "" {
        didSet {
            searchForPOI(text: poiText)
        }
    }

    @Published var viewData = [LocationServiceData]()
    
    var service: LocationService
    
    init(center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)) {
        service = LocationService(in: center)
        cancellable = service.localSearchPublisher.sink { mapItems in
            self.viewData = mapItems.map({ LocationServiceData(mapItem: $0) })
        }
    }
    private func searchForCity(text: String) {
        service.searchCities(searchText: text)
    }
    
    private func searchForPOI(text: String) {
        service.searchPointOfInterests(searchText: text)
    }
}


