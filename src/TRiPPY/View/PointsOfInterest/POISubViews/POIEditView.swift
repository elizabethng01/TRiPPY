//
//  POIEditView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/13/22.
//
//View to edit visit
import SwiftUI

struct POIEditView: View {
    @EnvironmentObject var modelData : ModelData
    @ObservedObject var trip : Trip
    var poi : POI
    @State var newCategory : String = "OTHER"
    @State var newRating : Int = 0
    @Binding var editing : Bool
    
    //find trip and poi index so changes made are permanent
    @State var poiIndex : Int
    var tripIndex : Int {
        modelData.trips.firstIndex( where: {$0.id == trip.id})!
    }
    
    var body: some View {
        VStack {
            Text(trip.visits[poiIndex].name)
                .textCase(.uppercase)
                .font(Font.custom("HelveticaNeue-Thin",size:17))
                .padding(.top, 5)
                .padding(.bottom, 35)
            Spacer()
            VStack (alignment: .leading) {
                HStack {
                    Text("PRIORITY:")
                        .font(Font.custom("HelveticaNeue-Thin",size:12))
                        .padding(.trailing)
                    Spacer()
                    StarRatingView(stars : $newRating)
                }
                .padding(.bottom,10)
                Text("CATEGORY")
                    .font(Font.custom("HelveticaNeue-Thin",size:12))
                CategoryRadioGroup(callback: {
                    selected in
                    newCategory = selected
                }, tSize: 7, selectedId: trip.visits[poiIndex].category)
            }
            Button(action: {
                print("Saving edits")
                modelData.trips[tripIndex].visits[poiIndex].category = newCategory
                modelData.trips[tripIndex].visits[poiIndex].priority = newRating
                modelData.update()
                editing = false
            }){
                Text("SAVE")
                    .font(Font.custom("HelveticaNeue-Thin",size: 14))
            }
            .foregroundColor(Color.white)
            .padding(4)
            .frame(width: 60)
            .background(Color.orange)
            .cornerRadius(40)
            .padding(.top,10)
        }
        .onAppear {
            newCategory = trip.visits[poiIndex].category
            newRating = trip.visits[poiIndex].priority
        }

    }
}

struct POIEditView_Previews: PreviewProvider {
    static var previews: some View {
        POIEditView(trip: ModelData().defaultTrips[0], poi : POI(name: "Lona Misa", subtitle: "234 Toorak South VIC Australia", id: UUID(), category: Category.food.rawValue, coordinates: Coordinates(latitude: 0,longitude: 0), priority: 3), editing: Binding.constant(true), poiIndex : 0).environmentObject(ModelData())
            .frame(width: 300, height: 250)
    }
}
