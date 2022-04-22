//
//  SplashScreen.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/15/22.
//

import SwiftUI

struct SplashScreen: View {
    @State var animationAmount = 1.0
    var body: some View {
        ZStack {
            Color.orange
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack (spacing:1){
                    Text("TR")
                        .font(Font.custom("HelveticaNeue-Thin",size:80))
                    Image(systemName: "mappin.and.ellipse")
                        .font(Font.custom("HelveticaNeue-Thin",size:60))
                    Text("PPY")
                        .font(Font.custom("HelveticaNeue-Thin",size:80))
                }
                    .foregroundColor(.white)
                    .rotationEffect(Angle(degrees:180-(animationAmount*179)))
                    .scaleEffect(animationAmount)
                    .opacity(2-animationAmount)
                .animation(.easeInOut(duration:1).repeatForever(autoreverses: true),value:animationAmount)
                Spacer()
                Text("ELIZABETH NG")
                    .font(Font.custom("HelveticaNeue-Thin", size:10))
                    .kerning(8)
                    .foregroundColor(.white.opacity(0.6))
                    .padding(.bottom,10)

            }
        }
        .onAppear{
            animationAmount = 2
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
