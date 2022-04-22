//
//  AddPOIView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/9/22.
//
//View to add new visit to trip

import SwiftUI
import MapKit

struct AddPOIView: View {
    
    @EnvironmentObject var modelData : ModelData
    @Binding var isPresented : Bool
    @ObservedObject var locationService: LocationService
    @StateObject var locationData : LocationServiceModel
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.7617,
                                       longitude: 80.1918),
        span: MKCoordinateSpan(
            latitudeDelta:10,
            longitudeDelta:10)
    )
    @State private var category = 1
    @State private var isEditing = false
    @State private var showResults = false
    
    @State var searchResults : [LocationServiceData] = []
    
    @ObservedObject var trip: Trip
    
    @State var toAddName : String = ""
    @State var toAddPriority : Int = 0
    @State var toAddID : UUID = UUID()
    @State var toAddCoordinates : CLLocationCoordinate2D = CLLocationCoordinate2D()
    @State var toAddCategory : String = "OTHER"
    @State var toAddSubtitle : String = ""
    @State var starRating : Int = 0
    
    
    //https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui#:~:text=Pure%20SwiftUI%20(iOS%2015)&text=To%20dismiss%20the%20keyboard%2C%20simply,automatically%20(since%20iOS%2014).
    enum Field: Hashable {
        case myField
    }
    @FocusState private var focusedField: Field?
    
    func updateRegion() {
        region = MKCoordinateRegion(
            center: trip.dest.locationCoordinate,
            span: MKCoordinateSpan(
                latitudeDelta:0.75,
                longitudeDelta:0.75)
        )
    }
    
    func focusMap(center: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta:0.02,
                longitudeDelta:0.02)
        )
    }
    
    var body: some View {
        VStack {
            Text("ADD VISIT")
                .font(Font.custom("HelveticaNeue-Thin", size: 25))
                .kerning(5)
            ZStack {
                VStack {
                    Map(coordinateRegion: $region, annotationItems: searchResults){ item in
                        MapMarker(coordinate: item.coordinate, tint: .orange)
                    }
                    .cornerRadius(40)
                    
                    //simplify view if user is editing text field so there is more screen spsace for map/search results
                    if !isEditing  {
                        VStack (alignment: .leading) {
                            Text("CATEGORY:")
                                .font(Font.custom("HelveticaNeue-Thin",size: 15))
                            CategoryRadioGroup {
                                selected in
                                toAddCategory = selected
                            }
                        }
                        .padding(.top,15)
                        
                        HStack {
                            Text("PRIORITY:")
                                .font(Font.custom("HelveticaNeue-Thin",size:16))
                            Spacer()
                            StarRatingView(stars : $starRating)
                            
                        }
                        .padding(20)
                        
                        Button(action: {
                            if toAddName != "" {
                                print("adding new visit")
                                let toAdd = POI(name: toAddName, subtitle: toAddSubtitle, id: toAddID, category: toAddCategory, coordinates: Coordinates(latitude: toAddCoordinates.latitude, longitude: toAddCoordinates.longitude), priority: starRating)
                                trip.visits.append(toAdd)
                                modelData.save()
                            }
                            isPresented = false
                            
                        }){
                            Text("ADD VISIT")
                                .font(Font.custom("HelveticaNeue-Thin",size: 17))
                        }
                        .foregroundColor(Color.white)
                        .padding(12)
                        .frame(width: 200)
                        .background(Color.orange)
                        .cornerRadius(40)
                    }
                }
                //overlay search bar on top of map
                VStack {
                    TextField("Search...", text: $locationData.poiText)
                        .font(Font.custom("HelveticaNeue-THIN", size: 15))
                        .foregroundColor(.black)
                        .padding(7)
                        .padding(.horizontal,25)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.95)))
                        .onTapGesture {
                            self.isEditing = true
                            self.showResults = true
                            updateRegion()
                            self.searchResults = locationData.viewData
                        }
                        .focused($focusedField, equals: .myField)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)
                                    .foregroundColor(Color.black.opacity(0.3))
                         
                                if isEditing {
                                    Button(action: {
                                        self.locationData.poiText = ""
                                        isEditing = false
                                        showResults = false
                                        focusedField = nil

                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                        )
                        .frame(width:330)
                    
                    //show floating dropdown list of results if user is searching
                    if (showResults && locationData.poiText != "") {
                        List(locationData.viewData) { item in
                            VStack(alignment: .leading) {
                                Button(item.title) {
                                    print("selecting visit")
                                    self.locationData.poiText = "\(item.title)"
                                    self.toAddName = item.title
                                    self.toAddCoordinates = item.coordinate
                                    self.toAddID = item.id
                                    self.toAddSubtitle = item.subtitle
                                    showResults = false
                                    focusMap(center: item.coordinate)
                                    self.searchResults = [item]
                                    isEditing = false
                                    focusedField = nil
                                }
                                .font(Font.custom("HelveticaNeue-Thin",size:15))
                                Text(item.subtitle)
                                    .font(Font.custom("HelveticaNeue-Thin",size:12))
                            }
                        }.listStyle(.inset)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius:20).stroke(Color.black.opacity(0.1),lineWidth:1))
                            .frame(idealWidth: 330, maxHeight: 200)
                            .padding(.vertical,-8)
                    }
                }
                .offset(y: UIScreen.main.bounds.height/25)
            }
        }.onAppear {
            updateRegion()
        }
    }
}

struct AddPOIView_Previews: PreviewProvider {
    static var previews: some View {
        AddPOIView(isPresented: Binding.constant(true), locationService: LocationService(), locationData: LocationServiceModel(center: CLLocationCoordinate2D(latitude: -37.815031, longitude: 144.966347)), trip: Trip(dest: Destination(name: "Melbourne", state: "VIC", id: UUID(), country: "Australia", coordinates: Coordinates(latitude: -37.815031, longitude: 144.966347))))
            .environmentObject(ModelData())

    }
}
