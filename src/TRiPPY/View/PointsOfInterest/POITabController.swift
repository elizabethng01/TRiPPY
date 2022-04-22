//
//  POITabController.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/10/22.
//

//Tab Controller view for destinations
import SwiftUI
import MapKit

struct POITabController: View {
    @EnvironmentObject var modelData : ModelData
    @ObservedObject var trip: Trip
    
    @State private var selection = 2
    @State private var showPopover = false
    @State var filter = 0
    
    var region : MKCoordinateRegion {
        MKCoordinateRegion(
            center: trip.center,
            span: MKCoordinateSpan(
                latitudeDelta: trip.latDelta,
                longitudeDelta: trip.longDelta
            ))
    }
    
    private var hotelSearch : HotelSearchService {
        HotelSearchService(region: region)
    }
    private var hotelModel : HotelSearchModel {
        HotelSearchModel(region: region)
    }

    var body: some View {
        TabView (selection:$selection) {
            //tab item to add visit shown as popover, set underlying view as poiview to give popover a smooth transition in and out
            POIView(trip: trip)
                .tabItem {
                    Label("Add Visit", systemImage: "plus")
                        .font(Font.custom("HelveticaNeue-THIN", size: 10))
                }
                .tag(1)
                .onAppear {
                    self.showPopover = true
                }
            
            POIView(trip: trip)
                .tabItem {
                    Label("Visits", systemImage: "mappin.and.ellipse")
                        .font(Font.custom("HelveticaNeue-THIN", size: 10))
                }
                .tag(2)

            HotelView(trip: trip, hotelSearch: hotelSearch, searchData: hotelModel, radius : max(trip.longDelta,trip.latDelta))
                .tabItem {
                    Label("Find Hotels", systemImage: "bed.double")
                        .font(Font.custom("HelveticaNeue-Thin", size: 10))
                }
                .tag(3)
        }
        .accentColor(.orange)
        .popover(isPresented: $showPopover){
            AddPOIView(isPresented: $showPopover, locationService: LocationService(), locationData: LocationServiceModel(center: trip.dest.locationCoordinate),trip: trip)
                .environmentObject(self.modelData)
                .padding(15)
                .onDisappear {
                    //set tab controller back to initial visit view once popover is dismissed
                    selection = 2
                }
        }

        .toolbar {
            Text(trip.dest.name)
                .textCase(.uppercase)
                .font(Font.custom("HelveticaNeue-Thin", size: 28))
        }
    }
}

struct POITabController_Previews: PreviewProvider {
    static var previews: some View {
        POITabController(trip : Trip(dest: Destination(name: "Melbourne", state: "VIC", id: UUID(), country: "Australia", coordinates: Coordinates(latitude: -37.815031, longitude: 144.966347)))).environmentObject(ModelData())
    }
}
// Remove back button text
extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}
