//
//  BetaTestValidationView.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/28/23.
//

import SwiftUI
import FirebaseAuth

struct BetaTestValidationView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    
    var body: some View {
        ZStack {
            Image("White_Lotus_Field")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                Text("Welcome to the Radiant Beta!")
                    .foregroundColor(.black)
                    .font(.system(size: 26, design: .serif))
                    .padding(.top, 200)
                
                Text("Thank you so much for checking out my app, it really means a lot to me :) I'd love any and all feedback you have, enjoy! - Ben")
                    .foregroundColor(.black)
                    .font(.system(size: 18, design: .serif))
                    .padding(20)
                
                Spacer()
                
                
                RoundedRectangle(cornerRadius: 25)
                    .frame(maxHeight: 300)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.061, brightness: 0.928))
                    .overlay {
                        VStack(alignment: .center) {
                            Text("Enter your code below to continue to the app")
                                .padding(20)
                                .font(.system(size: 18, design: .serif))
                                .foregroundColor(.black)
                            
                            // Email text field
                            TextField("Enter code here", text: $authStateManager.betaCode)
                                .foregroundColor(Color.black)
                                .padding(.leading, 20)
                                .cornerRadius(50)
                                .frame(maxWidth: 300, minHeight: 40)
                                .font(.system(size: 25, design: .default))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                                .padding(.bottom, 15)
                            
                            
                            
                            
                            Button(action: {
                                print("user wanted to enter their beta code")
                                
                                // check auth status first
                                if let user = Auth.auth().currentUser?.uid {
                                    authStateManager.checkBetaCode(code: authStateManager.betaCode, user: user)
                                }
                            }) {
                                Text("Submit")
                            }
                            
                        }
                        .padding(.bottom, 60)
                    }
                
                
                //                Text("If you have a beta code please enter it below to continue to the app")
                //                    .foregroundColor(.white)
                //                    .font(.system(size: 26, design: .serif))
                //                    .padding(.bottom, 200)
            }
            .padding(.bottom, 20)
            
            
            
            
        }
    }
}

struct BetaTestValidationView_Previews: PreviewProvider {
    static var previews: some View {
        BetaTestValidationView()
            .environmentObject(AuthStatusManager())
    }
}
