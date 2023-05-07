//
//  ProfileMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

import SwiftUI

struct ProfileMainView: View {
    var body: some View {
        
        ZStack {
            Image("Profile_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Text("Welcome to your profile!")
        }
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView()
    }
}
