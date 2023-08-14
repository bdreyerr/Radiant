//
//  BottomNavBar.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore

struct BottomNavBar: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    
    @State private var tabBarBackground = "Home_BG"
    
    var body: some View {
        ZStack {
            
            Image(tabBarBackground)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            

            
            TabView() {
               
                
                Group {
                    HomeMainView()
                        .tabItem {
                            Image(systemName: "house")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                                .onAppear {
                                    tabBarBackground = "Home_BG"
                                }
                        }
                    
//                    MapMainView()
                    HistoryMainView()
                        .tabItem {
                            Image(systemName: "clock.fill")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                                .onAppear {
                                    tabBarBackground = "Map_BG"
                                }
                        }
                    ForumMainView()
                        .tabItem {
                            Image(systemName: "person.3.fill")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                                .onAppear {
                                    tabBarBackground = "Forum_BG3"
                                }
                        }
                    ChatMainView(text: "")
                        .tabItem {
                            Image(systemName: "message")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                                .onAppear {
                                    tabBarBackground = "Home_BG"
                                }
                        }
                    
                    ProfileMainView()
                        .tabItem {
                            Image(systemName: "person.fill")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                                .onAppear {
                                    tabBarBackground = "Profile_BG"
                                }
                        }
                }
                .toolbar(.visible, for: .tabBar)
                .toolbarBackground(Color.clear, for: .tabBar)
                
                // Find a way to always show the tab bar, OR go back on the comunity forum when the tab is switched to a non-community tab bar.
            }
            //                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}
