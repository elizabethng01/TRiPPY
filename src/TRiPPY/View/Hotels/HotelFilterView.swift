//
//  HotelFilterView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/14/22.
//
//Popover filter for hotels
import SwiftUI

struct HotelFilterView: View {
    
    @Binding var radius : Double
    @Binding var rating : Int
    @Binding var showPopover : Bool
    var body: some View {
        VStack {
            Text("FILTER HOTELS")
                .font(Font.custom("HelveticaNeue-Thin", size: 20))
            Spacer()
            HStack (alignment: .top) {
                Text("RADIUS:")
                    .font(Font.custom("HelveticaNeue-Thin", size: 15))
                Spacer()
                VStack {
                    //slider for radius in kilometers
                    Slider(value: $radius,in: 0.0...0.09)
                    Text(("~ \(radius*110.574, specifier: "%.1f") KILOMETERS"))
                            .font(Font.custom("HelveticaNeue-Thin",size:9))
                }
                .frame(width:150)
                .accentColor(.orange)
            }
            Spacer()
            HStack {
                Text("TRiPPY RATING:")
                    .font(Font.custom("HelveticaNeue-Thin", size: 15))
                Spacer()
                ButtonThumbRating(rating : $rating)
            }
            Spacer()
                Button (action: {
                    print("dismiss filter")
                    showPopover = false
                }) {
                    Text("SAVE")
                        .font(Font.custom("HelveticaNeue-Thin",size: 14))
                }
                .foregroundColor(Color.white)
                .padding(4)
                .frame(width: 60)
                .background(Color.orange)
                .cornerRadius(40)
        }
        .padding()
    }
}

struct HotelFilterView_Previews: PreviewProvider {
    static var previews: some View {
        HotelFilterView(radius: Binding.constant(0.04), rating: Binding.constant(1), showPopover: Binding.constant(true))
            .frame(width:300,height:300)
    }
}
