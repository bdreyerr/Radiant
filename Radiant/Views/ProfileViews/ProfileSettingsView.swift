//
//  ProfileSettingsView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/9/23.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    // MARK: - Variables
    
    @State private var isDarkMode = false
    @State private var language = "English"
    
    // MARK: - Available Languages
    
    private var availableLanguages = ["English", "Spanish", "French", "German", "Japanese"]
    
    var body: some View {
        ZStack {
            Image("Profile_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                
                List {
                    HStack {
                        Image("default_prof_pic")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(.trailing, 10)
                        
                        if let email = profileStateManager.userProfile?.email {
                            Text("\(email)")
                        } else {
                            Text("TestEmail@google.com")
                        }
                        
                        Button(action: {
                            
                        }) {
                            Image(systemName: "info.circle")
                        }
                    }
                    
                    
                    
                    Section(header: Text("Account Details")) {
                        // Email
                        HStack {
                            Text("Email: ")
                                .bold()
                            if let email = profileStateManager.userProfile?.email {
                                Text("\(email)")
                            } else {
                                Text("TestEmail@google.com")
                            }
                            
                            Button(action: {
                                print("User wanted to change email")
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                        
                        // Birthday
                        HStack {
                            Text("Birthday: ")
                                .bold()
                            if let bday = profileStateManager.userProfile?.birthday {
                                Text(bday, style: .date)
                            } else {
                                Text(Date.now, style: .date)
                            }
                            
                            Button(action: {
                                print("User wanted to change birthday")
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                        
                        // Weight
                        HStack {
                            Text("Weight: ")
                                .bold()
                            if let weight = profileStateManager.userProfile?.weight {
                                Text("\(weight)kg")
                            } else {
                                Text("60kg")
                            }
                            
                            Button(action: {
                                print("User wanted to change weight")
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                        
                        // Height
                        HStack {
                            Text("Height: ")
                                .bold()
                            if let height = profileStateManager.userProfile?.height {
                                Text("\(height)m")
                            } else {
                                Text("1.2m")
                            }
                            
                            Button(action: {
                                print("User wanted to change height")
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                        
                        
                        
                    }
                    
                    
                    Section(header: Text("Community Forum")) {
                        
                        // Display Name
                        HStack {
                            Text("Display Name: ")
                                .bold()
                            if let displayName = profileStateManager.userProfile?.displayName {
                                if profileStateManager.isForumAnon == true {
                                    let anonDisplayName = profileStateManager.userProfile?.anonDisplayName
                                    Text("\(anonDisplayName!)")
                                } else {
                                    Text("\(displayName)")
                                }
                            } else {
                                Text("")
                            }
                            
                            Button(action: {
                                print("User wanted to change displayName")
                            }) {
                                Image(systemName: "info.circle")
                            }
                            
                        }
                        
                        Toggle(isOn: $profileStateManager.isForumAnon, label: {
                            Text("Appear anonymous on the forum")
                        })
                        Toggle(isOn: $profileStateManager.isProfanityFiltered, label: {
                            Text("Filter profanity")
                        })
                    }
                    
                    Section(header: Text("Account")) {
                        Button(action: {
                            // Sign out of account
                            authStateManager.logOut()
                        }) {
                            Text("Sign Out")
                        }
                    }
                }
            }.padding(.top, 50)
            
            
        }
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}
