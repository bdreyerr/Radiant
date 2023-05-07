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
                BottomNavBar(authStateManager: authStateManager)
            }
        }
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(authStateManager: AuthStatusManager())
    }
}
