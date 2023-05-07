//
//  ForumMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

import SwiftUI

struct ForumMainView: View {
    var body: some View {
        ZStack {
            Image("Forum_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            Text("Welcome to the Forum View!")
        }
    }
}

struct ForumMainView_Previews: PreviewProvider {
    static var previews: some View {
        ForumMainView()
    }
}
