//
//  DestinationGrid.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/8/22.
//

import SwiftUI
//View for grid items
struct DestinationGrid: View {
    var name : String
    var country : String
    var body: some View {
        ZStack {
            Color.orange
            VStack {
                Text("\(name),")
                    .padding(2)
                    .font(Font.custom("HelveticaNeue-Light",size:25))
                Text(country)
                    .font(Font.custom("HelveticaNeue-Light",size:15))
            }.foregroundColor(Color.white)
            
        }
    }
}

struct DestinationGrid_Previews: PreviewProvider {
    static var previews: some View {
        DestinationGrid(name: "Melbourne",country:"Australia")
            .environmentObject(ModelData())
            .previewLayout(.fixed(width:150,height: 150))
    }
}
