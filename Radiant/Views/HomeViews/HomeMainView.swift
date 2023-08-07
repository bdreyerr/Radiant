//
//  HomeMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

// Testing again, after

import SwiftUI
import UIKit
import Charts
import FirebaseFirestore
import FirebaseAuth
import AuthenticationServices

struct HomeMainView: View {
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @StateObject var homeManager = HomeManager()
    
    @State private var todaysDate = Date()
    
    @State var goalOneComplete = true
    @State var goalTwoComplete = false
    @State var goalThreeComplete = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Radiant_Home_BG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    HStack {
                        // User Image
                        Image(homeManager.userProfilePhoto)
                            .resizable()
                            .frame(width: 60, height: 60, alignment: .leading)
                            .clipShape(Circle())
                            .padding(.trailing, 10)
                        
                        
                        Text ("Hi, \(homeManager.userFirstName)!")
                            .foregroundColor(.black)
                            .font(.system(size: 18, design: .serif))
                            .animation(.easeInOut(duration: 1.0))
                        
                        // Notifcation Bell
                        //                        Image(systemName: "bell.fill")
                        //                            .resizable()
                        //                            .frame(width: 24, height: 26, alignment: .leading)
                        //                            .padding(.leading, 180)
                        //                            .foregroundColor(.black)
                        //
                        //                        Circle()
                        //                            .frame(width: 10, height: 10)
                        //                            .foregroundColor(.red)
                        //                            .offset(x: -20, y:-10)
                        
                        // Radiant Icon
                        Image("home_lotus")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .padding(.leading, 120)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    
                    
                    
                    VStack(alignment: .center) {
                        // Date
                        Text(todaysDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 30, design: .serif))
                            .foregroundColor(.black)
                            .bold()
                        
                        
                    }
                    .padding(.bottom, 10)
                    
                    
                    ScrollView {
                        VStack {
                            // Daily Affirmation
                            Text(homeManager.quoteOfTheDay)
                                .foregroundColor(.black)
                                .italic()
                                .font(.system(size: 16, design: .serif))
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                                .padding(.top, 20)
                                .padding(.bottom, 20)
                                .frame(alignment: .center)
                        
                            
                            if homeManager.hasUserCheckedInToday == false {
                                Button(action: {
                                    print("User wanted to check in")
                                    homeManager.isCheckInPopupShowing = true
                                }) {
                                    RoundedRectangle(cornerRadius: 40)
                                        .frame(maxWidth: 300, minHeight: 50, maxHeight: 200)
                                        .overlay {
                                            ZStack {
                                                Text("Check In")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 15, design: .serif))
                                            }
                                        }
                                }
                                .sheet(isPresented: $homeManager.isCheckInPopupShowing) {
                                    CheckInView()
                                        .onDisappear {
                                            if let user = Auth.auth().currentUser?.uid {
                                                homeManager.userInit(userID: user)
                                            } else {
                                                print("no user yet")
                                            }
                                        }
                                }
                                //                    .padding(10)
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                            } else {
                                Text("User has already checked in family.")
                            }
                            
                            // Goals
                            HStack {
                                Text("Goals")
                                    .bold()
                                    .font(.system(size: 22, design: .serif))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                //TODO: replace this date with the date of the last checkin
                                Text("Set on 7/26")
                                    .font(.system(size: 20, design: .serif))
                                    .foregroundColor(.black)
                                    .padding(.leading, 180)
                            }
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            
                            
                            // Goals
                            VStack(alignment: .center) {
                                // Goal one
                                GoalView(goalText: homeManager.goals[0], goalHue: 1.0, goalSaturation: 0.111)
                                
                                // Goal two
                                GoalView(goalText: homeManager.goals[1], goalHue: 0.797, goalSaturation: 0.111)
                                
                                // Goal three
                                GoalView(goalText: homeManager.goals[2], goalHue: 0.542, goalSaturation: 0.226)
                            }
                            .padding(.bottom, 20)
                            
                            
                            // Gratitude
                            VStack {
                                
                                HStack {
                                    Text("Gratitude")
                                        .bold()
                                        .font(.system(size: 22, design: .serif))
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                
                                Text(homeManager.gratitude)
                                    .font(.system(size: 18, design: .serif))
                                    .foregroundColor(.black)
                                    .italic()
                                    .padding(.top, 10)
                            }
                            .padding(.leading, 20)
                            
                            
                            ActivitiesModule()
                                .padding(.bottom, 40)
                            
                            
                            EducationModule()
                            
                            
                        }
                        .padding(.top, 10)
                    }
                    .padding(.bottom, 100)
                }
                .padding(.top, 60)
                
            }
            .onAppear {
                if let user = Auth.auth().currentUser?.uid {
                    homeManager.userInit(userID: user)
                } else {
                    print("no user yet")
                }
                
                print("has user checked in: \(homeManager.hasUserCheckedInToday)")
            }
            .environmentObject(homeManager)
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
    }
}


struct GoalView: View {
    let goalText: String?
    
    let goalHue: CGFloat?
    let goalSaturation: CGFloat?
    
    @State var goalComplete = false
    
    var body: some View {
        Button(action: {
            print("goal complete")
            goalComplete = !goalComplete
        }) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(hue: goalHue!, saturation: goalSaturation!, brightness: 1.0))
                .frame(width: 360, height: 70, alignment: .leading)
                .overlay {
                    VStack() {
                        if goalComplete {
                            Text(goalText!)
                                .foregroundColor(.green)
                                .font(.system(size: 16, design: .serif))
                        }
                        else {
                            Text(goalText!)
                                .foregroundColor(.black)
                                .font(.system(size: 16, design: .serif))
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
                    
                    if goalComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 26, alignment: .leading)
                            .foregroundColor(.green)
                            .offset(x: 175, y: -38)
                    }
                }
        }
        
        
    }
}

struct MoodData: Identifiable {
    let id = UUID()
    let day: String
    let val: Double
}

struct MoodGraphModule: View {
    @EnvironmentObject var homeManager: HomeManager
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(Color(hue: 0.686, saturation: 0.707, brightness: 0.165))
                .frame(minWidth: 360, maxWidth: 360, minHeight: 160, maxHeight: 160)
                .overlay {
                    HStack {
                        Text("Happiness")
                            .foregroundColor(.blue)
                            .padding(10)
                        
                        Text("Depression")
                            .foregroundColor(.orange)
                            .padding(10)
                        
                        Text("Anxiety")
                            .foregroundColor(.green)
                            .padding(10)
                    }
                    .offset(y: -50)
                    
                    Group {
                        Chart(0..<self.homeManager.visibleHappinessScores.count, id: \.self)
                        { nr in
                            LineMark(
                                x: .value("X values", nr),
                                y: .value("Y values", self.homeManager.visibleHappinessScores[nr])
                            )
                        }
                        .foregroundColor(.blue)
                        .padding(20)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        
                        Chart(0..<self.homeManager.visibleDepressionScores.count, id: \.self)
                        { nr in
                            LineMark(
                                x: .value("X values", nr),
                                y: .value("Y values", self.homeManager.visibleDepressionScores[nr])
                            )
                        }
                        .foregroundColor(.orange)
                        .padding(20)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                        
                        Chart(0..<self.homeManager.visibleAnxietyScores.count, id: \.self)
                        { nr in
                            LineMark(
                                x: .value("X values", nr),
                                y: .value("Y values", self.homeManager.visibleAnxietyScores[nr])
                            )
                        }
                        .foregroundColor(.green)
                        .padding(20)
                        .chartXAxis(.hidden)
                        .chartYAxis(.hidden)
                    }
                    .offset(y: 40)
                    
                }
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct ActivitiesModule: View {
    var activities = ["Quiz1", "Quiz2", "Quiz3"]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Activities")
                    .foregroundColor(.black)
                    .font(.system(size: 22, design: .serif))
                    .bold()
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    //                    ActivityView(bg_image: "Chat_BG", completed: false, title: "Personality Quiz")
                    
                    CharacterAchetypeView()
                    
                    HealthyRelationshipActivityView()
                    
                    JournalingPromptsActivityView()
                }
            }
            
        }
        .padding(.leading, 20)
    }
}


struct EducationModule: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Education")
                    .foregroundColor(.black)
                    .font(.system(size: 22, design: .serif))
                    .bold()
                Spacer()
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ThinkingErrorsView()
                    
                    EducationArticleView(bg_image: "Register_Email_BG", completed: false, title: "The Brain and the Prefrontal Cortex")
                    
                    EducationArticleView(bg_image: "Register_BG", title: "Linked Thought Patterns & Nuerons")
                }
            }
        }
        .padding(.leading, 20)
    }
}
