//
//  ContentView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var authStateManager = AuthStatusManager()
    
    
    var body: some View {
        
        ZStack {
            WelcomeView()
            if (!authStateManager.isLoggedIn) {
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
