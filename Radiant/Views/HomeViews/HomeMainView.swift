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
                    UserOverviewView()
                        .padding(.bottom, 40)
                    
                    
//                    Divider().frame(width: 300, height: 0.5).overlay(Color.white).padding(.trailing,20)
                    
                    ActivitiesView()
                        .padding(.bottom, 40)
                    
//                    Divider().frame(width: 300, height: 0.4).overlay(Color.white)
//                        .padding(.trailing,20)
                    
                    EducationView()
                        .padding(.bottom, 40)
                }
                .padding(.bottom, 50)
                
            }
            .padding(.leading, 20)
            .padding(.bottom, 30)
            .padding(.top, 100)
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
    }
}


struct UserOverviewView: View {
    var body: some View {
        VStack {
            
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.blue)
                .frame(minWidth: 340, maxWidth: 200, minHeight: 200, maxHeight: 200)
                .overlay {
                    Image("graph")
                        .resizable()
                        .frame(width: 340, height:200)
                        .cornerRadius(25)
                }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Goals:")
                        .foregroundColor(.white)
                        .bold()
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.green)
                        
                        Text ("Workout Monday")
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.green)
                        
                        Text ("Go to therapy")
                            .foregroundColor(.white)
                    }
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.black)
                        
                        Text ("Cook a chicken dinner")
                            .foregroundColor(.white)
                    }
                }
                .padding(20)
                .border(Color.orange, width: 3)
                
                
                VStack(alignment: .leading) {
                    Text ("Daily affirmation: ")
                        .foregroundColor(.white)
                        .bold()
                    Text ("I am capable of great things. I believe in myself and my abilities. I am goated at everything I do.")
                        .foregroundColor(.white)
                }
                .padding(20)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .border(Color.blue, width: 3)
                
                
            }
            
        }
        
        
        .padding(.trailing, 20)
        
        
    }
}

struct ActivitiesView: View {
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


struct EducationView: View {
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


