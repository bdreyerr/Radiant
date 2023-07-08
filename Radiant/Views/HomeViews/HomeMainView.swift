//
//  HomeMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

import SwiftUI

struct HomeMainView: View {
    var body: some View {
        ZStack {
            Image("Home_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                ScrollView {
                    WelcomeModule()
                    
                    GoalsModule()
                        .padding(.bottom, 40)
                    
                    
                    MoodGraphModule()
                    
                    ActivitiesModule()
                        .padding(.bottom, 40)
                    

                    
                    EducationModule()
                        .padding(.bottom, 40)
                }
                .padding(.bottom, 50)
                
            }
            .padding(.leading, 20)
            .padding(.bottom, 30)
            .padding(.top, 60)
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
    }
}

struct WelcomeModule: View {
    var body: some View {
        
        RoundedRectangle(cornerRadius: 25)
            .frame(minWidth: 360, minHeight: 400)
            .overlay {
                ZStack {
                    Image("Home_Welcome_BG")
                        .resizable()
                        .frame(width: 360, height:400)
                        .cornerRadius(25)
                    
                    VStack {
                        Text("Radiant")
                            .font(.system(size: 40, weight: .bold))
                            .padding(10)
                            .offset(y: -40)
                        
                        // Daily Affirmation
                        Text("\"The future belongs to those who believe in the beauty of their dreams\" - Eleanor Roosevelt")
                            .foregroundColor(.blue)
                            .italic()
                            .padding(10)
                            .offset(y: -40)
                        
                        
                        // Check in prompt OR recommended activity/education
                        VStack {
                            Text("You haven't checked in yet today")
                                .foregroundColor(.orange)
                                .bold()
                            Button(action: {
                                print("User wanted to initiate their daily check in")
                            }) {
                                
                                RoundedRectangle(cornerRadius: 40)
                                    .frame(maxWidth: 250, maxHeight: 50)
                                    .foregroundColor(.green)
                                    .overlay {
                                        Text("Check In")
                                            .foregroundColor(.white)
                                    }
                            }
                        }
                        .offset(y: 60)
                        
                        
                    }
                    .padding(20)
                    .padding(.bottom, 20)
                }
            }.padding(.trailing, 20)
    
        
//        VStack(alignment: .leading) {
//            Text ("Daily affirmation: ")
//                .foregroundColor(.white)
//                .bold()
//            Text ("I am capable of great things. I believe in myself and my abilities. I am goated at everything I do.")
//                .foregroundColor(.white)
//        }
//        .padding(20)
//        .clipShape(RoundedRectangle(cornerRadius: 30))
//        .border(Color.blue, width: 3)
    }
}


struct GoalsModule: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 25)
                    .frame(minWidth: 360, minHeight: 250, maxHeight: 300)
                    .overlay {
                        ZStack {
                            Image("Home_Goals_BG")
                                .resizable()
                                .frame(width: 360, height:250)
                                .cornerRadius(25)
                            
                            VStack(alignment: .leading) {
                                Text("Your Goals for Today")
                                    .foregroundColor(.white)
                                HStack {
                                    Image(systemName: "checkmark.square.fill")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.green)
                                    Text("Call Brenda")
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Image(systemName: "square")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.gray)
                                    Text("Study for math test")
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Image(systemName: "checkmark.square.fill")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.green)
                                    Text("Study for math test")
                                        .foregroundColor(.white)
                                }
                                VStack(alignment: .center) {
                                    Text("You haven't set your goals for today")
                                        .foregroundColor(.orange)
                                        .bold()
                                    
                                    Button(action: {
                                        print("User wanted to update their goals")
                                    }) {
                                        RoundedRectangle(cornerRadius: 40)
                                            .frame(maxWidth: 200, maxHeight: 50)
                                            .foregroundColor(.orange)
                                            .overlay {
                                                Text("Set Goals")
                                                    .foregroundColor(.white)
                                            }
                                    }
                                }
                            }
                        }

                        
                    }
            }
        }
        .padding(.trailing, 20)
    }
}

struct MoodGraphModule: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.blue)
                .frame(minWidth: 360, maxWidth: 360, minHeight: 200, maxHeight: 200)
                .overlay {
                    Image("graph")
                        .resizable()
                        .frame(width: 360, height:200)
                        .cornerRadius(25)
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


