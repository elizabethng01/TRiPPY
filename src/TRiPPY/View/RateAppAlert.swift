//
//  RateAppAlert.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/14/22.
//

import SwiftUI

//Custome rate app alert - shows after user has opened the app 3 times
struct RateAppAlert: View {
    @Binding var isShowing : Bool
    @Binding var rating : Int
    var body: some View {
        VStack (spacing: 10) {
            Text("ENJOYING TRiPPY?")
                .font(Font.custom(("HelveticaNeue-Thin"), size: 20))
                .foregroundColor(.black)
                .padding(.top)
            Text(("Rate us in the App Store!"))
                .font(Font.custom(("HelveticaNeue-Thin"), size: 16))
                .foregroundColor(.black)
            StarRatingView(stars: $rating)
                .padding(.bottom,8)
                .foregroundColor(.white)
            Button {
                isShowing = false
            } label : {
                Text("SUBMIT")
                    .font(Font.custom(("HelveticaNeue-Thin"), size: 13))
                    .foregroundColor(.white)
                    .padding(.vertical,7)
                    .padding(.horizontal,10)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.orange))
            }
        }

    }
}

struct RateAppAlert_Previews: PreviewProvider {
    static var previews: some View {
        RateAppAlert(isShowing: Binding.constant(true), rating: Binding.constant(0))
    }
}
