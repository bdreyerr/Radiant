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
    
    @ObservedObject var authStateManager = AuthStatusManager()
    
//    var isUserLoggedIn = UserDefaults.standard.object(forKey: loginStatusKey) as? Bool
    
    var body: some View {
        
        ZStack {
            WelcomeView(authStateManager: authStateManager)
            
            
            
            
            // Main App Flow
            
            
            // Welcome Survey flow
            
            
            // Show the register / login screen either if the loginStatus is nil, or false
            if let loginStatus = UserDefaults.standard.object(forKey: loginStatusKey) as? Bool {
                if loginStatus == false {
                    RegisterView(authStateManager: authStateManager)
                }
            } else {
                RegisterView(authStateManager: authStateManager)
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
