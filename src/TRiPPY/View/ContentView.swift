//
//  ContentView.swift
//  TRiPPY
//
//  Created by Elizabeth Ng on 3/8/22.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var monitor = NetworkMonitor()
    @EnvironmentObject var modelData : ModelData
    
    //to check if user is no longer active - save data if so
    @Environment(\.scenePhase) var scenePhase
    @AppStorage("timesOpened") var timesOpened : Int = 0
    @State var showRateAlert : Bool = false
    
    //for app star rating
    @State var rating : Int = 0
    
    @State private var showSplash = true
    @State private var showContent = false
    var body: some View {
        
        ZStack {
            if showSplash {
                SplashScreen()
                    .onTapGesture {
                        self.showSplash = false
                    }
            }
            //rate app alert on 3rd open
            if showRateAlert {
                    RateAppAlert(isShowing: $showRateAlert, rating: $rating)
                        .frame(width:250,height:170)
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white.opacity(0.9)).shadow(radius:2))
                        .onDisappear {
                            showContent = true
                        }
            }
            if showContent {
                //save data when user puts app in background
                DestinationsView()
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .inactive {
                            modelData.save()
                        } else if newPhase == .background {
                            modelData.save()
                        }
                    }
            }
        }
        .onAppear {
            showSplash = true
            if timesOpened == 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM y"
                let date = dateFormatter.string(from: Date.now)
                UserDefaults.standard.register(defaults: ["initial_launch": date])
                UserDefaults.standard.set(date, forKey: "initial_launch")
                UserDefaults.standard.synchronize()
            }
            //update times opened until rating view is shown
            if timesOpened < 4 {
                timesOpened += 1
            }
            //show splash screen for 0.8 seconds, update view to either show app rating alert or content
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8, execute: {
                self.showSplash = false
                if timesOpened == 3 {
                    showRateAlert = true
                }
                else {
                    showContent = true
                }
            })
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
