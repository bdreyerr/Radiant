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
    
    // Controls display of sidebar
    @State var showSidebar: Bool = false
    
    // Todo: Move this to the user's profile, should be stored in firebase I guess?
    @State var forumProfanityToggle: Bool = false
    
    var body: some View {
        
        SideBarStack(sidebarWidth: 280, showSidebar: $showSidebar) {
            // Sidebar content here
            
            NavigationView {
                ZStack {
                    //                Image("Sidebar_BG")
                    //                    .resizable()
                    //                    .scaledToFill()
                    //                    .edgesIgnoringSafeArea(.all)
                    
                    
                    VStack(alignment: .center) {
                        
                        HStack {
                            Image("default_prof_pic")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            Text("southxx")
                            //                            .foregroundColor(.white)
                        }
                        .padding(.bottom, 15)
                        
                        
                        NavigationLink(destination: MyPosts(), label: {
                            Rectangle()
                                .frame(width: 220, height: 50)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .overlay() {
                                    Text("My Posts")
                                        .foregroundColor(.white)
                                }
                        })
                        .padding(.bottom, 15)
                        
                        NavigationLink(destination: MyComments(), label: {
                            Rectangle()
                                .frame(width: 220, height: 50)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .overlay() {
                                    Text("My Comments")
                                        .foregroundColor(.white)
                                }
                        })
                        .padding(.bottom, 15)
                        
                        NavigationLink(destination: LikedPosts(), label: {
                            Rectangle()
                                .frame(width: 220, height: 50)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .overlay() {
                                    Text("Liked Posts")
                                        .foregroundColor(.white)
                                }
                        })
                        .padding(.bottom, 15)
                        
                        Toggle(isOn: $forumProfanityToggle, label: {
                            Text("Appear anonymous on the forum")
                        })
                        
                    }
                    .padding(.bottom, 400)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                }
            }
        } content: {
            NavigationView {
                ZStack {
                    // This is the background image.
                    Image("Forum_BG3")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .leading) {
                        // Icons
                        HStack {
                            // Forum side bar
                            Button(action: {
                                print("User wanted to open side bar view")
                                showSidebar = true
                            }) {
                                Image(systemName: "text.alignleft")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                            .padding(.trailing, 5)
                            
                            // Notifications
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 20, height: 20)
                            
                        }
                        .padding(.top, 80)
                        .padding(.leading, 20)
                        .padding(.bottom, 20)
                        
                        
                        ZStack {
                            ForumCategoriesView()
                        }
                    }
                }
            }
            .foregroundColor(Color(uiColor: .white))
            .environmentObject(forumManager)
        }.edgesIgnoringSafeArea(.all)
        
        
    }
}

struct ForumMainView_Previews: PreviewProvider {
    static var previews: some View {
        ForumMainView()
    }
}


struct MyPosts: View {
    var body: some View {
        Text("This is My Posts")
    }
}

struct MyComments: View {
    var body: some View {
        Text("This is My Comments")
    }
}


struct LikedPosts: View {
    var body: some View {
        Text("This is My Liked Posts")
    }
}
