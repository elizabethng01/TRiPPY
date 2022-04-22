//
//  CategoryRadioGroup.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/11/22.
//
//https://thinkdiff.net/how-to-create-radio-button-and-group-in-swiftui-46b34e0ba69a
//Radio buttons for category selection

import Foundation
import SwiftUI

//MARK:- Single Radio Button Field
struct RadioButtonField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: CGFloat
    let isMarked:Bool
    let callback: (String)->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 20,
        color: Color = Color.orange,
        textSize: CGFloat = 10,
        isMarked: Bool = false,
        callback: @escaping (String)->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.isMarked = isMarked
        self.callback = callback
    }
    
    var body: some View {
        Button(action:{
            self.callback(self.id)
        }) {
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "largecircle.fill.circle" : "circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                    .foregroundColor(self.color)
                Text(label)
                    .font(Font.custom("HelveticaNeue-Thin",size: textSize))
            }
                .padding(.horizontal)
        }
        .foregroundColor(.gray)
    }
}

//MARK:- Group of Radio Buttons

struct CategoryRadioGroup: View {
    let callback: (String) -> ()
    @State var tSize : CGFloat = 10
    @State var selectedId: String = ""
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                foodButton
                shoppingButton
                attractionButton
                otherButton
            }
        }
    }
    
    var foodButton: some View {
        RadioButtonField(
            id: Category.food.rawValue,
            label: Category.food.rawValue,
            textSize : tSize,
            isMarked: selectedId == Category.food.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var shoppingButton: some View {
        RadioButtonField(
            id: Category.shopping.rawValue,
            label: Category.shopping.rawValue,
            textSize : tSize,
            isMarked: selectedId == Category.shopping.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var attractionButton: some View {
        RadioButtonField(
            id: Category.attraction.rawValue,
            label: Category.attraction.rawValue,
            textSize : tSize,
            isMarked: selectedId == Category.attraction.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    var otherButton: some View {
        RadioButtonField(
            id: Category.other.rawValue,
            label: Category.other.rawValue,
            textSize : tSize,
            isMarked: selectedId == Category.other.rawValue ? true : false,
            callback: radioGroupCallback
        )
    }
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
    }
}
