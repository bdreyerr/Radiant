//
//  ContentView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct ContentView: View {
    
    @StateObject var authStateManager = AuthStatusManager()
    
    var body: some View {
        
        ZStack {
            // Show the WelcomeView or Register View depending on user login status stored in userDefaults
            if let loginStatus = UserDefaults.standard.object(forKey: loginStatusKey) as? Bool {
                
                // Show the register / login screen either if the loginStatus is nil, or false
                if loginStatus == false {
                    RegisterView()
                }
                
                // Welcome Survey flow
                // if this is user's first time signing into the app, show Welcome Survey
                
                
                // Main App Flow
                if loginStatus == true {
                    WelcomeView()
                        // Retrieve the UserProfile from firestore and store it in authStateManager.userProfile
                        .onAppear {
                            if let userID = Auth.auth().currentUser?.uid {
                                // This function is async, and code below it will not function properly if relying on authStateManager.userProfile
                                authStateManager.retrieveUserProfile(userID: userID)
                            } else {
                                print("The current user could not be retrieved")
                //                authStateManager.logOut()
                            }
                        }
                }
            } else {
                // Show the register / login screen either if the loginStatus is nil
                RegisterView()
            }
        }.environmentObject(authStateManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
