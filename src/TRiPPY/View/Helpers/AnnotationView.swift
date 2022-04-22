//
//  AnnotationView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/17/22.
//
//Custom annotations for hotel and visits in hotel view so they can be distinct

import SwiftUI

struct AnnotationView: View {
    var name : String
    var hotel : Bool
    var body: some View {
        
            if hotel {
                VStack(spacing:0) {
                    Image(systemName: "bed.double.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .orange)
                        .font(.title)
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .offset(x:0,y:-8)
                }
            }
            else {
                VStack(spacing:0) {
                    Image(systemName: "mappin.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .gray)
                        .font(.title)

                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .offset(x:0,y:-8)
                    Text(name)
                        .font(Font.custom("HelveticaNeue",size:10))
                }
            }
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            AnnotationView(name: "Chicago", hotel: true)
            AnnotationView(name: "Chicago", hotel: false)
        }

    }
}
