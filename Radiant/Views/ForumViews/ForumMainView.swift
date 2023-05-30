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
                        Capsule()
                            .frame(width:60,height:33)
                            .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6039008336)))
                        ZStack{
                            Circle()
                                .frame(width:30, height:30)
                                .foregroundColor(.white)
                            Image(systemName: toggleOn ? "message.fill" : "person.2.fill")
                                .foregroundColor(.black)
                        }
                        .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                        .offset(x:toggleOn ? 18 : -18)
                        .padding(10)
                        .animation(.spring(), value: toggleOn)
                    }
                    .onTapGesture {
                        self.toggleOn.toggle()
                    }
                    
                    if (!toggleOn) {
                        ForumCategoriesView()
                    } else {
                        RadiantBotChatView(text: "")
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
