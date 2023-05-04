//
//  RegisterView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

/*
 
 ToDos:
 - Redesign the text fields in the RegisterPopUpView
 - Fix the debug messages that popup when the keyboard opens
 - Make it so the text fields move up when the keyboard opens
 
 - Create a Register Controller which extracts all of the non UI related logic into a testable modulated controller class
 - Add a unit test which tests this Register controller logic
 
 - Setup the signup with Apple functionality and views

 
 
 */


import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var authStateManager: AuthStatusManager
    
    var body: some View {
        NavigationView() {
            ZStack {
                Image("Register_BG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    
                    // Register with email button
                    ActionButtonView(text: "Register with email", symbolName: "envelope.fill", action: {
                        authStateManager.isRegisterPopupShowing = true
                    }).sheet(isPresented: $authStateManager.isRegisterPopupShowing) {
                        RegisterWithEmailView(authStateManager: authStateManager)
                    }
                    
                    // Already a member prompt
                    HStack{
                        Text("Already a member?").foregroundColor(.white)
                        Button(action: {
                            authStateManager.isLoginPopupShowing = true
                        }) {
                            Text("Login").foregroundColor(.cyan).underline()
                        }.sheet(isPresented: $authStateManager.isLoginPopupShowing) {
                            LoginWithEmailView(authStateManager: authStateManager)
                        }
                    }.padding(.all, 8.0)
                    
                    
                    // Register with Apple button
                    ActionButtonView(text: "Sign in with Apple", symbolName: "apple.logo", action: {
                        print("Sign in with Apple button pressed")
                    })
                }.padding(.bottom, 75)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(authStateManager: AuthStatusManager())
    }
}
