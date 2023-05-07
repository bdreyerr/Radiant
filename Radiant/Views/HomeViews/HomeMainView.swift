//
//  HomeMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

import SwiftUI

struct HomeMainView: View {
    var body: some View {
        ZStack {
            Image("Home_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Text("Welcome to the Home View!")
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
    }
}
