//
//  CheckInView.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/9/23.
//

import SwiftUI

struct CheckInView: View {
    @StateObject var checkInManager = CheckInManager()
    
    @State private var happinessSliderValue = 5.0
    @State private var depressionSliderValue = 5.0
    @State private var anxietySliderValue = 5.0
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Image("CheckIn_BG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("How happy are you today? ")
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                        .font(.system(size: 18, design: .monospaced))
                        .bold()
                        .padding(20)
                    CirclularSlider(sliderValue: $checkInManager.happinessSliderVal)
                    
                    
                    NavigationLink(destination: DepressionView()) {
                        Text("Next")
                            .foregroundColor(.white)
                            .font(.system(size: 30, design: .monospaced))
                        Image(systemName: "arrow.right")
                            .foregroundColor(.white)
                    }
                    .offset(y: 200)
                    .padding(.bottom, 80)
                }
            }
        }.environmentObject(checkInManager)
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView()
    }
}


struct DepressionView: View {
    
    @EnvironmentObject var checkInManager: CheckInManager
    var body: some View {
        
        
        ZStack {
            Image("CheckIn_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Please rate your depression today: ")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(.system(size: 18, design: .monospaced))
                    .bold()
                    .padding(20)
                CirclularSlider(sliderValue: $checkInManager.depressionSliderVal)
                
                NavigationLink(destination: AnxeityView()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.system(size: 30, design: .monospaced))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .offset(y: 200)
                .padding(.bottom, 80)
            }
        }
        .padding(.bottom, 75)
    }
}


struct AnxeityView: View {
    @EnvironmentObject var checkInManager: CheckInManager
    var body: some View {
        
        ZStack {
            Image("CheckIn_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Text("Please rate your anxiety today: ")
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .font(.system(size: 18, design: .monospaced))
                    .bold()
                    .padding(20)
                CirclularSlider(sliderValue: $checkInManager.anxeitySliderVal)
                
                
                NavigationLink(destination: GoalsView()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.system(size: 30, design: .monospaced))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .offset(y: 200)
                .padding(.bottom, 80)
            }
            
        }
        .padding(.bottom, 50)
    }
}


struct GoalsView: View {
    @EnvironmentObject var checkInManager: CheckInManager
    
    var body: some View {
        ZStack {
            Image("CheckIn_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("What are your goals for today?")
                    .foregroundColor(.white)
                    .font(.system(size: 20, design: .monospaced))
                
                TextField("Enter text", text: $checkInManager.goalOne)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .padding(20)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                    )
                
                TextField("Enter text", text: $checkInManager.goalTwo)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .padding(20)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                    )
                
                TextField("Enter text", text: $checkInManager.goalThree)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .padding(20)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                    )
                
                NavigationLink(destination: GratitudeView()) {
                    Text("Next")
                        .foregroundColor(.white)
                        .font(.system(size: 30, design: .monospaced))
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
                .offset(y: 200)
                .padding(.bottom, 80)
            }
        }
    }
}

struct GratitudeView: View {
    @EnvironmentObject var checkInManager: CheckInManager
    @EnvironmentObject var homeManager: HomeManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    var body: some View {
        ZStack {
            Image("CheckIn_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Text("What are you grateful for today?")
                    .foregroundColor(.white)
                    .font(.system(size: 20, design: .monospaced))
                
                TextField("Enter text", text: $checkInManager.gratitude)
                    .padding(.leading, 10)
                    .foregroundColor(.white)
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .padding(20)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                    )
                
                Button(action: {
                    if let user = profileStateManager.userProfile {
                        checkInManager.checkIn(userID: user.id!)
                    }
                    homeManager.isCheckInPopupShowing = false
                }) {
                    Text("Finish Check In")
                }
            }
        }
    }
}
