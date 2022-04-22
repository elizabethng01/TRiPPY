//
//  POIRow.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/12/22.
//
//Custom list row for visits
import SwiftUI

struct POIRow: View {
    
    @State var poi : POI
    @EnvironmentObject var modelData : ModelData
    var tripIndex : Int
    var poiIndex : Int {
        modelData.trips[tripIndex].visits.firstIndex(where: {$0.id == poi.id}) ?? 0
    }
    
    var body: some View {
        HStack {
            VStack (alignment: .leading){
                Text(modelData.trips[tripIndex].visits[poiIndex].name)
                    .font(Font.custom("HelveticaNeue-Thin",size: 17))
                Text(modelData.trips[tripIndex].visits[poiIndex].category)
                    .font(Font.custom("HelveticaNeue-Thin",size: 12))
            }
            Spacer()
            
            StaticStarRating(rating: $modelData.trips[tripIndex].visits[poiIndex].priority)
                .padding(.trailing,-15)
        }
    }
}

struct POIRow_Previews: PreviewProvider {
    static var previews: some View {
        POIRow(poi : POI(name: "Gong de Lin", id: UUID(), category: Category.food.rawValue, coordinates: Coordinates(latitude: 0,longitude: 0), priority: 3),tripIndex : 0)
            .environmentObject(ModelData())
            .previewLayout(.fixed(width:300,height:70))
    }
}
