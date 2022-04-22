//
//  POIDescription.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/13/22.
//
//View to show description of visit when clicked
import SwiftUI

struct POIDescriptionView: View {
    @EnvironmentObject var modelData : ModelData
    @ObservedObject var trip : Trip
    
    var poi :  POI
    
    @Binding var showDescription : Bool
    @Binding var editing : Bool
    
    @Binding var rating : Int
    
    //index of visit in model data
    var poiIndex : Int {
        trip.visits.firstIndex(where: { $0.id == poi.id}) ?? 0
    }
    //index of trip in model data
    var tripIndex : Int {
        modelData.trips.firstIndex(where: {$0.id == trip.id}) ?? 0
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack (alignment: .leading){
                    Text(poi.name)
                        .font(Font.custom("HelveticaNeue-Regular",size:15))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(poi.subtitle)
                        .font(Font.custom("HelveticaNeue-Thin",size:12))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }.padding(.leading)
                Spacer()
                VStack (alignment: .trailing) {
                    Button {
                        showDescription = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }.foregroundColor(Color.black.opacity(0.5))
                        .padding(.trailing,5)
                        .padding(.top,8)
                    
                    VStack (alignment: . trailing ){
                        StaticStarRating(rating: $modelData.trips[tripIndex].visits[poiIndex].priority)
                            .scaleEffect(0.75)
                            .padding(.trailing, -25)
                        Text(modelData.trips[tripIndex].visits[poiIndex].category)
                            .font(Font.custom("HelveticaNeue-Thin", size:10))
                    }
                        .padding(.trailing)
                    //custom popover to edit visit
                    WithPopover(
                        showPopover: $editing,
                        popoverSize : CGSize(width:300, height: 250), arrowDirections: [.up],
                        content: {
                            Button("EDIT") {
                                editing = true
                            }
                            .padding(.horizontal,6)
                            .padding(.vertical,3)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.orange))
                            .font(Font.custom("HelveticaNeue-Thin",size:11))
                            .foregroundColor(Color.white)
                            .padding(.trailing)
                            .padding(.bottom,10)
                        },
                        popoverContent: {
                            POIEditView(trip: trip, poi: trip.visits[poiIndex], editing: $editing, poiIndex: poiIndex).environmentObject(self.modelData)
                                .padding()
                                .onDisappear {
                                    showDescription = false
                                }
                        }
                    )
                }
            }.foregroundColor(.black)
        }
    }
}

struct POIDescription_Previews: PreviewProvider {
    static var previews: some View {
        POIDescriptionView(trip : ModelData().defaultTrips[0], poi : POI(name: "Lona Misa", subtitle: "234 Toorak South VIC Australia", id: UUID(), category: Category.food.rawValue, coordinates: Coordinates(latitude: 0,longitude: 0), priority: 3), showDescription: Binding.constant(true), editing: Binding.constant(true), rating:  Binding.constant(3)).environmentObject(ModelData())
            
    }
}
