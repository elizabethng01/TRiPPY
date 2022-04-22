//
//  DestinationsView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/8/22.
//
//Initial destination view to see all user trips
import SwiftUI

struct DestinationsView: View {
    
    @State var showAddDest = false
    
    @EnvironmentObject var modelData : ModelData
    
    //track if user is editing trips
    @State var isEditing = false
    
    //columns for LazyVGrid
    let columns = [GridItem(.flexible()),GridItem(.flexible())]
    
    @State var deleteDestAlert = false
    
    //Store ID of trip user is looking to delete
    @State var deleteID : UUID = UUID()
    var body: some View {

        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    //If user hasn't added any trips, show default trips
                    if (modelData.trips.count == 2 && modelData.trips[0].id == modelData.defaultTrips[0].id){
                        Text("PRESS + TO ADD A DESTINATION")
                            .font(Font.custom("HelveticaNeue-Thin",size : 22))
                            .padding(.vertical,50)
                            .padding(.leading,8)
                        Text("Or take a look at some of our favourite destinations      ↓")
                            .font(Font.custom("HelveticaNeue-Thin",size : 16))
                            .padding(.vertical,50)
                        ForEach(modelData.trips) { trip in
                            NavigationLink {
                                POITabController(trip: trip)
                            } label: {
                                DestinationGrid(name: trip.dest.name, country: trip.dest.country)
                                    .frame(height: 150)
                                    .cornerRadius(25)
                                    .padding(5)
                            }
                        }
                    }
                    //If user has added trips, show only user trips and not any default trips
                    else {
                        ForEach(modelData.trips.filter { trip in
                            trip.id != modelData.defaultTrips[0].id && trip.id != modelData.defaultTrips[1].id
                        }) { trip in
                            NavigationLink {
                                POITabController(trip: trip)
                            } label: {
                                DestinationGrid(name: trip.dest.name, country: trip.dest.country)
                                    .frame(height: 150)
                                    .cornerRadius(25)
                                    .padding(5)
                                
                                //disable navigation link if user is editing trips
                            }.disabled(isEditing || showAddDest)
                            //only show delete button overlay if user is editing
                                .overlay (
                                    Button(action: {
                                        self.deleteDestAlert.toggle()
                                        deleteID = trip.id
                                        
                                    }){
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title)
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, .red)
                                            .opacity(isEditing ? 1.0 : 0.0)
                                            .disabled(!isEditing)
                                    }
                                    .offset(x: 75, y: -70)
                                    
                                    //present alert to warn user when they want to delete a trip
                                        .alert(isPresented: $deleteDestAlert,content:{
                                            Alert(
                                                title: Text("Are you sure?")
                                                ,
                                                message: Text("This action cannot be undone")
                                                ,
                                                primaryButton: .destructive(Text("Delete"), action: {
                                                    isEditing = false
                                                    if let index = modelData.trips.firstIndex(where : {$0.id == deleteID}){
                                                        modelData.trips.remove(at: index)
                                                    }
                                                    modelData.update()
                                                }),
                                                secondaryButton: .destructive(Text("Cancel"), action: {
                                                    isEditing = false
                                                }) )
                                        } )
                                )
                                .rotationEffect(.degrees(isEditing ? 5 : 0))                            
                        }
                    }
                }
                .padding(.all,15)
            }
            .navigationTitle("DESTINATIONS")
            .blur(radius: showAddDest ? 20 : 0)
            .toolbar{
                //Edit toolbar option
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.isEditing.toggle()
                        print("Editing trips")
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .disabled(modelData.trips.count == 2 && modelData.trips[0].id == modelData.defaultTrips[0].id)
                    }
                }
                //Add destination toolbar option with custom popover
                ToolbarItem(placement: .navigationBarTrailing) {
                    WithPopover(
                        showPopover: $showAddDest,
                        popoverSize: CGSize(width:350, height: 450), arrowDirections: [.up],
                        content: {
                            Button(action: {
                                self.showAddDest.toggle()
                                print("Add new destination popover")
                            }) {
                                Image(systemName: "plus")
                            }
                        },
                        popoverContent: {
                            AddDestinationView(locationService: LocationService(), showPopover: $showAddDest).environmentObject(self.modelData)
                        })
                }
            }
        }
        .accentColor(.orange)
        .onAppear {
            let appearance = UINavigationBar.appearance()
            let font = UIFont(name: "HelveticaNeue-Thin", size: 40)
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.font: font!]
        }
    }
    //find id of destination to delete and delete
    private func deleteDest(trip: Trip){
        if let index = self.modelData.trips.firstIndex(of: trip) {
            self.modelData.trips.remove(at: index)
        }
    }
}

struct DestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationsView().environmentObject(ModelData())
    }
}
