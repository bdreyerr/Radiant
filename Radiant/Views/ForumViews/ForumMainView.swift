//
//  ForumMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

import SwiftUI

struct ForumMainView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @StateObject var forumManager = ForumManager()
    
    @State var toggleOn =  false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                // This is the background image.
                Image("Forum_BG3")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                
                VStack {
                    // Icons
                    HStack {
                        // Notifications
                        Image(systemName: "bell")
                            .resizable()
                            .frame(width: 20, height: 20)
//                        // User forum settings
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .padding(.top, 80)
                    .padding(.leading, 300)
                    .padding(.bottom, 20)
                    
                    
                    ZStack {
                        ForumCategoriesView()
                    }
                }
            }
        }
        .foregroundColor(Color(uiColor: .white))
        .environmentObject(forumManager)
    }
}

struct ForumMainView_Previews: PreviewProvider {
    static var previews: some View {
        ForumMainView()
    }
}
