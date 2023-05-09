//
//  ProfileSettingsView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/9/23.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    
//    @ObservedObject var profileStateManager = ProfileStatusManager()
    
    var body: some View {
        ZStack {
            Image("Profile_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
