//
//  AddDestinationView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/9/22.
//
//View for user to add a destination
import SwiftUI
import MapKit

struct AddDestinationView: View {
    @EnvironmentObject var modelData : ModelData
    @ObservedObject var locationService: LocationService
    @StateObject private var locationData = LocationServiceModel()
    
    //track if user is typing in search
    @State private var isEditing = false
    
    @Binding var showPopover : Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    //To store variables for new destination
    @State var toAddName : String = ""
    @State var toAddCountry : String = ""
    @State var toAddCoordinates = CLLocationCoordinate2D()
    @State var toAddState : String = ""
    @State var toAddID = UUID()
    
    var body: some View {
        VStack {
            Text("ADD NEW DESTINATION")
                .font(Font.custom("HelveticaNeue-Thin",size:25))
            VStack (alignment: .leading ){
                Form {
                    Section(header: Text("Destination: ").font(Font.custom("HelveticaNeue-Thin",size:12))) {
                        //https://www.appcoda.com/swiftui-search-bar/
                        ZStack(alignment: .trailing) {
                            TextField("Search...", text: $locationData.cityText)
                                .background(Color.clear)
                                .font(Font.custom("HelveticaNeue-Thin",size:15))
                                .padding(7)
                                .padding(.horizontal,25)
                                .overlay(RoundedRectangle(cornerRadius:25).stroke(lineWidth:1).foregroundColor(Color.black.opacity(0.3)))
                                .onTapGesture {
                                    self.isEditing = true
                                }
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 8)
                                            .foregroundColor(Color.black.opacity(0.3))
                                 
                                        if isEditing {
                                            Button(action: {
                                                self.locationData.cityText = ""
                                                self.locationData.viewData = []
                                                isEditing = false
                                            }) {
                                                Image(systemName: "multiply.circle.fill")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 8)
                                            }
                                        }
                                    }
                                )
                        }
                        .background(Color.clear)
                    }
                    Section(header: Text("Results").font(Font.custom("HelveticaNeue-Thin",size:12))) {
                        List(locationData.viewData) { item in
                            VStack(alignment: .leading) {
                                Button(item.title) {
                                    self.locationData.cityText = "\(item.title), \(item.country)"
                                    self.toAddName = item.title
                                    self.toAddCountry = item.country
                                    self.toAddCoordinates = item.coordinate
                                    self.toAddState = item.state
                                    self.toAddID = item.id
                                }
                                .font(Font.custom("HelveticaNeue-Thin",size:15))
                                Text(item.subtitle)
                                //Text("\(item.state), \(item.country)")
                                    .font(Font.custom("HelveticaNeue-Thin",size:12))
                            }
                        }
                    }
                }
                .padding(.trailing)
            }
            Spacer()
            Button(action: {
                print("Adding new destination")
                if toAddName != "" {
                    let newDest = Destination(name: toAddName, state: toAddState, id: toAddID, country: toAddCountry, coordinates: Coordinates(toAddCoordinates))
                    modelData.trips.append(Trip(dest: newDest))
                    modelData.save()
                }
                showPopover = false
            }){
                Text("LET'S GET TRiPPY!")
                    .font(Font.custom("HelveticaNeue-Thin",size:16))
            }
            .foregroundColor(Color.white)
            .padding(10)
            .frame(width: 200,height:35)
            .background(Color.orange)
            .cornerRadius(40)
        }
        .padding(.vertical,30)
        .onAppear{
            UITableView.appearance().backgroundColor = .clear
        }
    }
}

struct AddDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        AddDestinationView(locationService: LocationService(), showPopover: Binding.constant(true))
            .frame(width: 340, height: 500).environmentObject(ModelData())
    }
}
