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
    
    var body: some View {
        ZStack {
            VStack{
                
//                VStack {
//                    Button(action: {
//                        authStateManager.logOut()
//                    }) {
//                        Text("Log Out")
//                    }.background(Color.clear)
//
//
//                    if let user = Auth.auth().currentUser {
//                        Text("The current user is: \(user.email ?? "default email")").background(Color.clear)
//                    } else {
//                        Text("The current user is nil af").background(Color.clear)
//                    }
//                }.background(Color.clear)
                
                
                TabView() {
                    HomeMainView()
                        .tabItem {
                            Image(systemName: "house")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                        }
                    
                    MapMainView()
                        .tabItem {
                            Image(systemName: "map")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                        }
                    ForumMainView()
                        .tabItem {
                            Image(systemName: "list.bullet")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                        }
                    ProfileMainView()
                        .tabItem {
                            Image(systemName: "person.fill")
                                .background(Color.white)
                                .foregroundColor(Color.blue)
                        }
                }
                .edgesIgnoringSafeArea(.bottom)
                
                
            }
            
            
            
            
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
