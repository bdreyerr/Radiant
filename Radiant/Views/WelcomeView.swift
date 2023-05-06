//
//  WelcomeView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct WelcomeView: View {
    
    @ObservedObject var authStateManager: AuthStatusManager
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("Welcome, you've been logged in to the app")
                Button(action: {
                    authStateManager.logOut()
                }) {
                    Text("Log Out")
                }
                
                if let user = Auth.auth().currentUser {
                    Text("The current user is: \(user.email ?? "default email")")
                } else {
                    Text("The current user is nil af")
                }
                
            }
        }
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(authStateManager: AuthStatusManager())
    }
}
