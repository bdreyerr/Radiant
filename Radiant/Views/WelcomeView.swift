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
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    
    
    var body: some View {
        ZStack {
            VStack {
                BottomNavBar()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
