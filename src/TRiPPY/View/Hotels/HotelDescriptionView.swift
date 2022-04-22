//
//  HotelDescriptionView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/13/22.
//
//View for hotel description
import SwiftUI

struct HotelDescriptionView: View {
    var hotel : LocationServiceData = LocationServiceData(poi: POI())
    @Binding var rating : Int
    @Binding var showDescription : Bool
    
    var body: some View {
        VStack {
            HStack  {
                VStack (alignment: .leading){
                    Text(hotel.title)
                        .font(Font.custom("HelveticaNeue-Regular",size:15))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(hotel.subtitle)
                        .font(Font.custom("HelveticaNeue-Thin",size:12))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }.padding(.leading)
                    .foregroundColor(.black)
                Spacer()
                VStack (alignment: .trailing) {
                    Button {
                        print("close description")
                        showDescription = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }.foregroundColor(Color.black.opacity(0.5))
                        .padding(.trailing,5)
                    VStack (alignment: .trailing){
                        Text("TRiPPY RATING: ")
                            .font(Font.custom("HelveticaNeue-Thin",size:10))
                            .foregroundColor(.orange)
                        ThumbRating(rating : $rating)
                    }.padding(.trailing)
                        .padding(.top)
                }
            }
        }
    }
}

struct HotelDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        HotelDescriptionView(hotel: LocationServiceData(poi: POI(name: "Lona Misa", subtitle: "234 Toorak South VIC Australia", id: UUID(), category: Category.food.rawValue, coordinates: Coordinates(latitude: 0,longitude: 0), priority: 3)), rating : Binding.constant(2), showDescription: Binding.constant(true)).environmentObject(ModelData())
            .frame(height:75)
    }
}
