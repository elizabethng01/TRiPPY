//
//  LocalSearchService.swift
//  WeddMate
//
//  Created by Robin Kment on 13/10/2020.
//  Copyright © 2020 Robin Kment. All rights reserved.
//
//https://kment-robin.medium.com/swiftui-location-search-with-mapkit-c64589990a66
//LOCATIONSEARCHSERVICE: This class allows users to search for a city or place of interest using Apple's MapKit MKLocalSearch

import Foundation
import Combine
import MapKit

final class LocationService: ObservableObject {
    let localSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    private var center: CLLocationCoordinate2D
    private var radius: CLLocationDistance
    
    
    init(in center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0,longitude: 0),
         radius: CLLocationDistance = 350_000) {
        self.center = center
        self.radius = radius
    }
    
    public func updateRegion(center: CLLocationCoordinate2D, radius: Double){
        self.center = center
        self.radius = CLLocationDistance(radius)
    }
    
    public func searchCities(searchText: String) {
        request(resultType: .address, searchText: searchText)
    }
    
    public func searchPointOfInterests(searchText: String) {
        request(searchText: searchText)
    }
    
    private func request(resultType: MKLocalSearch.ResultType = .pointOfInterest,
                         searchText: String, filter: MKPointOfInterestFilter = .includingAll ) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.pointOfInterestFilter = filter
        request.resultTypes = resultType
        request.region = MKCoordinateRegion(center: center,
                                            latitudinalMeters: radius,
                                            longitudinalMeters: radius)
        let search = MKLocalSearch(request: request)

        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }

            self?.localSearchPublisher.send(response.mapItems)
        }
    }
}
