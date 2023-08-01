//
//  WelcomeSurveyView.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/29/23.
//

import SwiftUI
import FirebaseAuth

struct WelcomeSurveyView: View {
    
//    @StateObject var welcomeSurveyManager = WelcomeSurveyManager()
    @EnvironmentObject var authStateManager: AuthStatusManager
    
    var body: some View {
        ZStack {
            Image("Welcome_Survey_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Welcome to Radiant")
                    .font(.system(size: 24, design: .serif))
                    .padding(.bottom, 40)
                
                Text("Please answer a few questions so we can know you better")
                    .font(.system(size: 18, design: .serif))
                    .padding(.bottom, 40)
                
                
                ScrollView {
                    VStack {
                        // Name
                        
                        VStack {
                            Text("What's your name?")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                            
                            TextField("Enter text", text: $authStateManager.name)
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                        .padding(20)
                                        .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                                )
                                .padding(.bottom, 20)
                        }
                        
                        // Photo
                        VStack {
                            Text("Would you like to upload a photo?")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                            
                            ZStack {
                                Image("Selection Mix II")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.white)
                                    .padding(.leading, 40)
                                    .padding(.bottom, 50)
                                
                                Button(action: {
                                    print("change image button pressed")
                                }) {
                                    Image(systemName: "square.and.pencil")
                                        .padding(.leading, 40)
                                        .padding(.bottom, 50)
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.bottom, 20)}
                        
                        // Birthday
                        VStack {
                            Text("When's your birthday?")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                            
                            DatePicker(selection: $authStateManager.birthday, in: ...Date(), displayedComponents: .date) {
                            }
                            .padding(.trailing, 140)
                            .padding(.bottom, 20)
                        }

                        // Display Name
                        VStack {
                            Text("What would you like your username to be?")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 20)
                            
                            Text("This is the name that will be used when you create a post on the community forum")
                                .foregroundColor(.black)
                                .font(.system(size: 16, design: .serif))
                                .padding(.leading, 20)
                            
                            
                            TextField("Enter text", text: $authStateManager.displayName)
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 10)
                                .foregroundColor(.black)
                                .padding(20)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 1)
                                        .padding(20)
                                        .frame(minWidth: 200, minHeight: 100, maxHeight: 160)
                                )
                                .padding(.bottom, 40)
                        }
                        
                        // Aspiration
                        VStack {
                            Text("What are you looking to get out of this app? (Select all)")
                                .foregroundColor(.black)
                                .font(.system(size: 20, design: .serif))
                                .padding(.leading, 20)
                                .padding(.bottom, 20)
                            
                            Aspiration(aspirationText: "Track my mood and goals", goalHue: 1.0, goalSaturation: 0.111)
                            
                            Aspiration(aspirationText: "Learn about my mental health via educative activities and articles", goalHue: 0.797, goalSaturation: 0.111)
                            
                            Aspiration(aspirationText: "Connect with a like minded community", goalHue: 0.542, goalSaturation: 0.111)
                            
                            Aspiration(aspirationText: "Find help in my area", goalHue: 0.324, goalSaturation: 0.111)
                        }
                        .padding(.bottom, 40)
                        
                        
                        if authStateManager.isErrorInSurvey {
                            Text(authStateManager.errorText)
                                .foregroundColor(.red)
                                .font(.system(size: 20, design: .serif))
                        }
                        // Submit
                        Button(action: {
                            print("User wanted to finish their welcome survey")
                            if let user = Auth.auth().currentUser?.uid {
                                authStateManager.completeWelcomeSurvey(user: user)
                            }
                        }) {
                            
                            RoundedRectangle(cornerRadius: 25)
                                .frame(maxWidth: 240, minHeight: 60)
                                .overlay {
                                    Text("Continue to Radiant")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, design: .serif))
                                }
                            
                        }
                        .padding(.bottom, 40)
                        
                    }
                    .padding(.bottom, 40)
                    .padding(.trailing, 20)
                    
                }
            }
            .padding(.top, 140)
            
        }
    }
}

struct WelcomeSurveyView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeSurveyView()
            .environmentObject(AuthStatusManager())
    }
}

struct Aspiration : View {
    let aspirationText: String?
    let goalHue: CGFloat?
    let goalSaturation: CGFloat?
    
    @State var aspirationSelected = false
    
    var body: some View {
        Button(action: {
            print("goal complete")
            aspirationSelected = !aspirationSelected
        }) {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(hue: goalHue!, saturation: goalSaturation!, brightness: 1.0))
                .frame(width: 360, height: 60, alignment: .leading)
                .overlay {
                    VStack() {
                        if aspirationSelected {
                            Text(aspirationText!)
                                .foregroundColor(.green)
                                .font(.system(size: 16, design: .serif))
                        }
                        else {
                            Text(aspirationText!)
                                .foregroundColor(.black)
                                .font(.system(size: 16, design: .serif))
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.leading, 20)
                    
                    if aspirationSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 26, alignment: .leading)
                            .foregroundColor(.green)
                            .offset(x: 175, y: -28)
                    }
                }
        }
    }
}
