//
//  LocalSearchService.swift
//  WeddMate
//
//  Created by Robin Kment on 13/10/2020.
//  Copyright © 2020 Robin Kment. All rights reserved.
//
//https://kment-robin.medium.com/swiftui-location-search-with-mapkit-c64589990a66

//HOTEL SEARCH SERVICE: This class automatically conducts hotel searchs given a region and stores the results as LocationServiceData objects

import Foundation
import Combine
import MapKit

final class HotelSearchService: ObservableObject {
    let localSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    private let region : MKCoordinateRegion

    init(region : MKCoordinateRegion){
        self.region = region
        request()
    }

    private func request() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "hotel"
        request.pointOfInterestFilter = MKPointOfInterestFilter.init(including: [MKPointOfInterestCategory.hotel])
        request.resultTypes = .pointOfInterest
        request.region = region
        let search = MKLocalSearch(request: request)

        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }
            self?.localSearchPublisher.send(response.mapItems)
        }
    }
}

final class HotelSearchModel: ObservableObject {
    private var cancellable: AnyCancellable?
    @Published var viewData = [LocationServiceData]()
    var service: HotelSearchService
    
    init(region: MKCoordinateRegion) {
        service = HotelSearchService(region: region)
        cancellable = service.localSearchPublisher.sink { mapItems in
            self.viewData = mapItems.map({ LocationServiceData(mapItem: $0) })
        
        }
    }
}
