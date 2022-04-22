//
//  HotelView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/10/22.
//
//View to search and look at conveniently located hotels
import SwiftUI
import MapKit

struct HotelView: View {
    
    @ObservedObject var trip: Trip
    @ObservedObject var monitor = NetworkMonitor()
    
    @State var hotelSearch: HotelSearchService
    @State var searchData : HotelSearchModel
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.7617,
                                       longitude: 80.1918),
        span: MKCoordinateSpan(
            latitudeDelta:10,
            longitudeDelta:10)
    )
    
    @State var filterPopover = false
    
    @State var buffering = true
    @State var showDescription = false
    //focus map on trip center
    func updateRegion(center : CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: radius,
                longitudeDelta: radius
            )
        )
    }
    //focucs map on hotel
    func focusMap(center: CLLocationCoordinate2D){
        region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )
    }
    
    @State var annotationItems : [LocationServiceData] = []
    @State var hotels : [LocationServiceData] = []
    
    @State var currHotel : LocationServiceData = LocationServiceData(poi: POI())
    @State var currHotelRating : Int = 1
    
    @State var radius : Double
    
    @State var rating : Int = 0
    //filter hotels by proximity to trip center and given radius/rating from filter
    func updateAnnotations() {
        hotels = searchData.viewData.filter { item in
            abs(item.coordinate.latitude - trip.center.latitude) <= radius &&
            abs(item.coordinate.longitude - trip.center.longitude) <= radius
            && item.rating(center: trip.center) >= rating
        }
        annotationItems = hotels
        for visit in trip.visits {
            annotationItems.append(LocationServiceData(poi: visit))
        }
    }
    
    var loading : Bool {
        searchData.viewData.isEmpty
    }
    var body: some View {
        ZStack {
            VStack {
                Text("HOTELS")
                    .font(Font.custom("HelveticaNeue-Thin",size:30))
                    .kerning(6)
                //show progress wheel if hotels/annotations still loading
                if loading || buffering {
                    ProgressView()
                        .scaleEffect(2)
                        .padding()
                }
                else {
                    Map(coordinateRegion: $region, annotationItems: annotationItems) { hotel in
                        hotel.marker
                    }
                    .cornerRadius(30)
                    .padding(.bottom,-8)
                        
                    VStack (alignment: .leading){
                        HStack (alignment: .center) {
                            Text("\(hotels.count) HOTELS FOUND")
                                .font(Font.custom("HelveticaNeue-Thin",size:20))
                            Spacer()
                            //custom popover for filter
                            WithPopover(
                                showPopover: $filterPopover,
                                popoverSize : CGSize(width:300,height:300),
                                arrowDirections: [.up],
                                content: {
                                    Button("FILTER") {
                                        print("show hotel filter")
                                        self.filterPopover.toggle()
                                    }
                                    .font(Font.custom("HelveticaNeue-Thin",size:15))
                                },
                                popoverContent: {
                                    HotelFilterView(radius: $radius, rating: $rating, showPopover: $filterPopover)
                                        .padding()
                                        .onDisappear{
                                            updateAnnotations()
                                            updateRegion(center: trip.center)
                                        }
                                })
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        List(hotels.sorted(by: {$0.distance(center: trip.center) < $1.distance(center: trip.center)})) { hotel in
                            HStack {
                                Button(hotel.title){
                                    focusMap(center: hotel.coordinate)
                                    currHotel = hotel
                                    currHotelRating = hotel.rating(center: trip.center)
                                    showDescription = true
                                }
                                .font(Font.custom("HelveticaNeue-Thin",size:15))
                                .frame(height:30)
                                Spacer()
                                VStack {
                                    HStack (spacing: 1) {
                                        Image(systemName: "hand.thumbsup")
                                        if(hotel.rating(center: trip.center)>1) {
                                            Image(systemName: "hand.thumbsup")
                                        }
                                        if(hotel.rating(center: trip.center)>2) {
                                            Image(systemName: "hand.thumbsup")
                                        }
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray.opacity(0.8))
                                }
                            }
                        }
                        .listStyle(.inset)
                    }
                    .padding(.top,-10)
                    .overlay(RoundedRectangle(cornerRadius:25).stroke(Color.gray.opacity(0.3),lineWidth:1))
                    Spacer()
                }
            }
            .padding(.horizontal)
            .onAppear {
                updateRegion(center: trip.center)
                //if network connection, update hotels since user may have added new visits
                if !monitor.isNotConnected {
                    hotelSearch = HotelSearchService(region: region)
                    searchData = HotelSearchModel(region: region)
                }
                updateAnnotations()
                //add buffer so annotations can load once search is complete
                if loading {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.buffering = true
                        updateAnnotations()
                        buffering = false
                    })
                }
                //sort hotels by proximity to trip center
                hotels = hotels.sorted(by: {$0.distance(center: trip.center) < $1.distance(center: trip.center)})
            }
            if showDescription {
                HotelDescriptionView(hotel: currHotel, rating: $currHotelRating, showDescription : $showDescription)
                    .padding(.vertical)
                    .frame(width: (UIScreen.main.bounds.size.width - 50),height:80)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(15)
                    .offset(y: -(UIScreen.main.bounds.size.height/4.2))
                    .onDisappear {
                        updateRegion(center: trip.center)
                    }
            }
        }
        .onDisappear{
            showDescription = false
        }
    }
}

struct HotelView_Previews: PreviewProvider {
    static var previews: some View {
        HotelView(
            trip: Trip(dest: Destination(name: "Melbourne", state: "VIC", id: UUID(), country: "Australia", coordinates: Coordinates(latitude: -37.815031, longitude: 144.966347))),
                  hotelSearch : HotelSearchService(region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -37.815031, longitude: 144.966347),
            span: MKCoordinateSpan(
                latitudeDelta: 0.001,
                longitudeDelta: 0.001
            )
        )),
                  searchData: HotelSearchModel(region: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -37.815031, longitude: 144.966347),
            span: MKCoordinateSpan(
                latitudeDelta: 0.001,
                longitudeDelta: 0.001
            )
        )),
            radius : 0).environmentObject(ModelData())
    }
}
