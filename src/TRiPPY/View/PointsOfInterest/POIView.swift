//
//  POIView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/10/22.
//
//Main view to see points of interest for a destination
import SwiftUI
import MapKit

struct POIView: View {
    
    @EnvironmentObject var modelData : ModelData
    
    @ObservedObject var trip: Trip
    //find trip index in model data array so any changes are permanent
    var tripIndex : Int {
        modelData.trips.firstIndex(where: {$0.id == trip.id}) ?? 0
    }
    
    @State var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -37.815031, longitude: 144.966347),
        span: MKCoordinateSpan(
            latitudeDelta:2,
            longitudeDelta:2)
    )
    
    @State var filter = "ALL"
    //update region when new visits are added
    func updateRegion(center : CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: trip.latDelta,
                longitudeDelta: trip.longDelta
            )
        )
    }
    //filter visits based on category choice
    var filteredVisits : [POI] {
        modelData.trips[tripIndex].visits.filter { visit in
            (filter == "ALL" || visit.category == filter)
        }
    }
    //store current poi if user is editing
    @State var currentPOI : POI = POI()
    
    @State var showDescription = false
    @State var editingPOI = false

    var body: some View {
        ZStack {
            VStack {
                    Map(coordinateRegion: $region, annotationItems: filteredVisits) { visit in
                        MapMarker(coordinate: visit.locationCoordinate, tint: .orange)
                    }
                        .cornerRadius(30)
                        
                    VStack {
                        //https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-segmented-control-and-read-values-from-it
                        Picker("Filters", selection: $filter) {
                            Text("ALL").tag("ALL")
                            Text("FOOD").tag("FOOD")
                            Text("ATTRACTION").tag("ATTRACTION")
                            Text("SHOPPING").tag("SHOPPING")
                            Text("OTHER").tag("OTHER")
                        }
                        .onChange(of: filter, perform: { (value) in
                            updateRegion(center: trip.center)
                            showDescription = false
                        })
                        .pickerStyle(.segmented)
                        
                        //default message if no trips added
                        if trip.visits.count == 0 {
                            Text("Add a visit to begin!")
                                .font(Font.custom("HelveticaNeue-Thin",size: 20))
                                .padding(.vertical,50)
                            Spacer()
                        }
                        else {
                            List {
                                ForEach(filteredVisits) { visit in
                                    Button {
                                        print("showing description")
                                        updateRegion(center: visit.locationCoordinate)
                                        currentPOI = visit
                                        showDescription = true
                                    } label: {
                                        POIRow(poi: visit, tripIndex : tripIndex)
                                            .frame(height : 38)
                                    }
                                }
                                //swipe to delete visit
                                .onDelete { indexSet in
                                    print("swipe to delete")
                                    filter = "OTHER"
                                    trip.visits.remove(atOffsets: indexSet)
                                    modelData.update()
                                    filter = "ALL"
                                    showDescription = false
                                }
                            }
                            .listStyle(.inset)
                            .padding(.vertical,-5)
                        }
                    }
                    .cornerRadius(25)
                    .overlay(RoundedRectangle(cornerRadius:25).stroke(Color.gray.opacity(0.3),lineWidth:1))
                    .padding(.top,-8)
                    Spacer()
                }
                .padding(.horizontal)
                .onAppear{
                    //set appearance for segmented control and update region and filter on appear
                    let appearance = UISegmentedControl.appearance()
                    appearance.selectedSegmentTintColor = .white
                    appearance.setTitleTextAttributes([.foregroundColor : UIColor.orange],  for: .selected)
                    let font = UIFont(name: "HelveticaNeue-Thin", size: 13)
                    appearance.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
                    updateRegion(center: trip.center)
                    modelData.update()
                }
            
            if showDescription {
                //overlay description view with current poi info
                ZStack {
                    POIDescriptionView(trip: trip, poi: currentPOI, showDescription: $showDescription, editing: $editingPOI, rating: $currentPOI.priority)
                        .padding(.vertical)
                        .frame(width:(UIScreen.main.bounds.size.width - 50),height:85)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(15)
                        .offset(y: -(UIScreen.main.bounds.size.height/3.4))
                        .onDisappear{
                            updateRegion(center: trip.center)
                            filter = "ALL"
                        }
                }
            }
        }
    }
}

struct POIView_Previews: PreviewProvider {
    static var previews: some View {
        POIView(trip: ModelData().defaultTrips[0]).environmentObject(ModelData())
    }
}
