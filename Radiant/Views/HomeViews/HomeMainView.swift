//
//  HomeMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

import SwiftUI
import Charts
import FirebaseFirestore
import FirebaseAuth
import AuthenticationServices

struct HomeMainView: View {
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @StateObject var homeManager = HomeManager()
    
    var body: some View {
        ZStack {
            Image("Home_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Image("Gold_Lotus")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                
                ScrollView {
                    WelcomeModule()
                        .padding(.bottom, 40)
                    
                    GoalsModule()
                        .padding(.bottom, 40)
                    
                    
                    MoodGraphModule()
                        .padding(.bottom, 40)
                    
                    ActivitiesModule()
                        .padding(.bottom, 40)
                    
                    
                    
                    EducationModule()
                        .padding(.bottom, 40)
                }
                .padding(.bottom, 50)
                .padding(.leading, 20)
                
            }
            
            .padding(.bottom, 30)
            .padding(.top, 60)
        }
        .onAppear {
            if let user = Auth.auth().currentUser?.uid {
                homeManager.userInit(userID: user)
            } else {
                print("no user yet")
            }
        }
        .environmentObject(homeManager)
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(HomeManager())
            .environmentObject(ProfileStatusManager())
    }
}

struct WelcomeModule: View {
    @EnvironmentObject var homeManager: HomeManager
    
    @State private var todaysDate = Date()
    var body: some View {
        
        RoundedRectangle(cornerRadius: 25)
            .frame(minWidth: 360, maxWidth: 360, minHeight: 300, maxHeight: 300)
        
            .overlay {
                ZStack {
                    Image("Home_Welcome_BG")
                        .resizable()
                        .frame(width: 360, height: 300)
                        .cornerRadius(25)
                    
                    
                    VStack {
                        // Date
                        Text(todaysDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 30, design: .monospaced))
                            .foregroundColor(Color(hue: 0.142, saturation: 0.267, brightness: 0.816))
                            .offset(y: -20)
                        
                        // Daily Affirmation
                        Text("\"The future belongs to those who believe in the beauty of their dreams\" - Eleanor Roosevelt")
                            .foregroundColor(Color(hue: 0.517, saturation: 0.205, brightness: 1.0))
                            .italic()
                            .font(.system(size: 15, design: .monospaced))
                            .padding(15)
                            .offset(y: -30)
                        
                        // Check In OR Radiant
                        
                        Button(action: {
                            print("User wanted to check in")
                            homeManager.isCheckInPopupShowing = true
                        }) {
                            RoundedRectangle(cornerRadius: 40)
                                .frame(maxWidth: 200, maxHeight: 60)
                                .overlay {
                                    ZStack {
                                        // image
                                        Image("CheckIn")
                                            .resizable()
                                            .frame(width: 200, height: 60)
                                            .cornerRadius(25)
                                        
                                        Text("Check In")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15, design: .monospaced))
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
                    }
                }
            }
            .padding(.trailing, 20)
    }
}


struct GoalsModule: View {
    @State var goalOneComplete = true
    @State var goalTwoComplete = false
    @State var goalThreeComplete = true
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var homeManager: HomeManager
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 360, maxWidth: 360, minHeight: 320, maxHeight: 320)
                    .overlay {
                        ZStack {
                            Image("Goals_BG")
                                .resizable()
                                .frame(width: 360, height:320)
                                .cornerRadius(25)
                            
                            VStack {
                                VStack(alignment: .center) {
                                    Text("Goals")
                                        .font(.system(size: 30, design: .monospaced))
                                        .foregroundColor(Color(hue: 0.142, saturation: 0.267, brightness: 0.816))
                                }
                                
                                VStack(alignment: .leading) {
                                    
                                    // Goal one
                                    Button(action: {
                                        goalOneComplete = !goalOneComplete
                                    }) {
                                        HStack {
                                            if goalOneComplete {
                                                Image(systemName: "checkmark.square.fill")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.green)
                                            } else {
                                                Image(systemName: "square")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            if homeManager.goals.count < 1 {
                                                Text("call brenda")
                                            } else {
                                                Text(homeManager.goals[0])
                                                    .foregroundColor(.white)
                                            }
                                            
                                        }
                                    }
                                    
                                    Button(action: {
                                        goalTwoComplete = !goalTwoComplete
                                    }) {
                                        HStack {
                                            if goalTwoComplete {
                                                Image(systemName: "checkmark.square.fill")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.green)
                                            } else {
                                                Image(systemName: "square")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            if homeManager.goals.count < 2 {
                                                Text("call brenda")
                                            } else {
                                                Text(homeManager.goals[1])
                                                    .foregroundColor(.white)
                                            }
                                            
                                        }
                                    }
                                    
                                    Button(action: {
                                        goalThreeComplete = !goalThreeComplete
                                    }) {
                                        HStack {
                                            if goalThreeComplete {
                                                Image(systemName: "checkmark.square.fill")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.green)
                                            } else {
                                                Image(systemName: "square")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.gray)
                                            }
                                            
                                            if homeManager.goals.count < 3 {
                                                Text("call brenda")
                                            } else {
                                                Text(homeManager.goals[2])
                                                    .foregroundColor(.white)
                                            }
                                            
                                        }
                                    }
                                }
                                //                                .offset(x: -60)
                                .padding(.bottom, 10)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)
                                
                                VStack(alignment: .center) {
                                    Text("Gratitude")
                                        .font(.system(size: 30, design: .monospaced))
                                        .foregroundColor(Color(hue: 0.142, saturation: 0.267, brightness: 0.816))
                                }
                                .padding(.bottom, 5)
                                
                                VStack(alignment: .leading) {
                                    Text(homeManager.gratitude)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        
                    }
            }
        }
        .padding(.trailing, 20)
        .onAppear {
            print("testing user ID from auth: \(Auth.auth().currentUser?.uid ?? "000")")
            //            homeManager.userInit(userID: Auth.auth().currentUser?.uid ?? "000")
        }
    }
}



struct MoodData: Identifiable {
    let id = UUID()
    let day: String
    let val: Double
}

struct MoodGraphModule: View {
    
    
    var h: [Double] = []
    let d: [Double] = []
    let a: [Double] = []
    
    @EnvironmentObject var homeManager: HomeManager
    
    var body: some View {
        VStack {
        
            
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.black)
                .frame(minWidth: 360, maxWidth: 360, minHeight: 160, maxHeight: 160)
                .overlay {
//                    Chart() {
//                        ForEach(happiness) { item in
//                            LineMark(
//                                x: .value("Day", item.day),
//                                y: .value("Val", item.val)
//                            )
//                        }
//
//                        ForEach(depression) { item in
//                            LineMark(
//                                x: .value("Day", item.day),
//                                y: .value("Val", item.val)
//                            )
//                        }
//
//                    }
//                    .frame(width: 360, height: 200)
//                    .foregroundColor(.blue)
                    
                    Chart(0..<self.homeManager.visibleHappinessScores.count, id: \.self)
                    { nr in
                        LineMark(
                            x: .value("X values", nr),
                            y: .value("Y values", self.homeManager.visibleHappinessScores[nr])
                        )
                    }
                    .foregroundColor(.blue)
                    .padding(20)
                    
                    Chart(0..<self.homeManager.visibleDepressionScores.count, id: \.self)
                    { nr in
                        LineMark(
                            x: .value("X values", nr),
                            y: .value("Y values", self.homeManager.visibleDepressionScores[nr])
                        )
                    }
                    .foregroundColor(.orange)
                    .padding(20)
                    
                    Chart(0..<self.homeManager.visibleAnxietyScores.count, id: \.self)
                    { nr in
                        LineMark(
                            x: .value("X values", nr),
                            y: .value("Y values", self.homeManager.visibleAnxietyScores[nr])
                        )
                    }
                    .foregroundColor(.green)
                    .padding(20)
                    
                    
                    HStack {
                        Text("Happiness")
                            .foregroundColor(.blue)
                        
                        Text("Depression")
                            .foregroundColor(.orange)

                        Text("Anxiety")
                            .foregroundColor(.green)
                    }
                    .offset(y: 50)
                                        
                }
        }
        .padding(.trailing, 20)
    }
}

struct ActivitiesModule: View {
    var activities = ["Quiz1", "Quiz2", "Quiz3"]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Activities")
                .foregroundColor(.white)
            
            ScrollView(.horizontal) {
                HStack {
                    Activity(bg_image: "Chat_BG", completed: false, title: "Personality Quiz")
                    
                    Activity(title: "Character Archtype")
                    
                    Activity(bg_image: "Register_BG", title: "Personality Quiz")
                }
            }
            
        }
    }
}


struct EducationModule: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Education")
                .foregroundColor(.white)
            
            ScrollView(.horizontal) {
                HStack {
                    Education(bg_image: "Profile_BG", completed: true, title: "Dopamine and Cortisal")
                    
                    Education(bg_image: "Register_Email_BG", completed: false, title: "The Brain and the Prefrontal Cortex")
                    
                    Education(bg_image: "Register_BG", title: "Linked Thought Patterns & Nuerons")
                }
            }
        }
    }
}


struct Activity: View {
    var bg_image = "Forum_BG2"
    var completed: Bool = true
    var title: String
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(minWidth: 250, maxWidth: 300, minHeight: 200, maxHeight: 200)
            .foregroundColor(.blue)
            .overlay {
                ZStack {
                    Image(bg_image)
                        .resizable()
                        .cornerRadius(25)
                    
                    VStack {
                        if completed {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.green)
                                .offset(y: -40)
                                .offset(x: 100)
                            
                        }
                        
                        Text(title)
                            .foregroundColor(.white)
                            .padding(.bottom, 40)
                    }
                }
            }
    }
}

struct Education: View {
    var bg_image = "Forum_BG2"
    var completed: Bool = true
    var title: String
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .frame(minWidth: 250, maxWidth: 300, minHeight: 200, maxHeight: 200)
            .foregroundColor(.blue)
            .overlay {
                ZStack {
                    Image(bg_image)
                        .resizable()
                        .cornerRadius(25)
                    
                    VStack {
                        if completed {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.green)
                                .offset(y: -40)
                                .offset(x: 100)
                            
                        }
                        
                        Text(title)
                            .foregroundColor(.white)
                            .padding(.bottom, 40)
                    }
                }
            }
    }
}


