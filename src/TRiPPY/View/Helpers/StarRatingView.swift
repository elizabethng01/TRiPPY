//
//  StarRatingView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/11/22.
//
//Star rating view with static option and clickable option
//https://trailingclosure.com/popup-review-button-using-swiftui/

import SwiftUI

struct RatingIcon: View {
    var filled : Bool = true
    var body: some View {
        Image(systemName: filled ? "star.fill" : "star")
            .foregroundColor(filled ? Color.yellow : Color.gray.opacity(0.6))
    }
}

struct StaticStarRating: View {
    @Binding var rating : Int
    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 0.5) {
                RatingIcon(filled: rating > 0)
                RatingIcon(filled: rating > 1)
                RatingIcon(filled: rating > 2)
                RatingIcon(filled: rating > 3)
                RatingIcon(filled: rating > 4)
            }
            .scaleEffect(0.75)
        }
    }
}
//Clickable star rating
struct StarRatingView: View {
    @Binding var stars : Int
    var body: some View {
        HStack {
            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    stars = 1
                }) {
                    RatingIcon(filled: stars > 0)
                }
                Button(action: {
                    stars = 2
                }) {
                    RatingIcon(filled: stars > 1)
                }
                Button(action: {
                    stars = 3
                }) {
                    RatingIcon(filled: stars > 2)
                }
                Button(action: {
                    stars = 4
                }) {
                    RatingIcon(filled: stars > 3)
                }
                Button(action: {
                    stars = 5
                }) {
                    RatingIcon(filled: stars > 4)
                }
            }
        }
    }
}

struct StarRatingView_Previews: PreviewProvider {
    static var previews: some View {
        StarRatingView(stars: Binding.constant(1))
    }
}
