//
//  ThumbRating.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/14/22.
//
//Thumb rating view for hotel rating with static and clickable option
import SwiftUI

struct ThumbRating: View {
    @Binding var rating : Int
    var body: some View {
        HStack (spacing: 1) {
            Image(systemName: "hand.thumbsup")
                .font(.caption)
                .foregroundColor(.gray.opacity(rating < 3 ? 0.0 : 0.8))
            Image(systemName: "hand.thumbsup")
                .font(.caption)
                .foregroundColor(.gray.opacity(rating < 2 ? 0.0 : 0.8))
            Image(systemName: "hand.thumbsup")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.8))

        }
    }
}

struct ButtonThumbRating: View {
    @Binding var rating : Int
    var body: some View {
        HStack (spacing: 1) {
            Button (action: {
                rating = 1
            }) {
                Image(systemName: rating < 1 ? "hand.thumbsup" : "hand.thumbsup.fill")
                .font(.caption)
                .foregroundColor(.orange.opacity(rating < 1 ? 0.4 : 1.0))
            }
            Button (action: {
                rating = 2
            }) {
                Image(systemName: rating < 2 ? "hand.thumbsup" : "hand.thumbsup.fill")
                .font(.caption)
                .foregroundColor(.orange.opacity(rating < 2 ? 0.4 : 1.0))
            }
            Button (action: {
                rating = 3
            }) {
            Image(systemName: rating < 3 ? "hand.thumbsup" : "hand.thumbsup.fill")
                .font(.caption)
                .foregroundColor(.orange.opacity(rating < 3 ? 0.4 : 1.0))
            }
        }
    }
}

struct ThumbRating_Previews: PreviewProvider {
    static var previews: some View {
        //ThumbRating(rating: Binding.constant(3))
        ButtonThumbRating(rating : Binding.constant(2))
    }
}
