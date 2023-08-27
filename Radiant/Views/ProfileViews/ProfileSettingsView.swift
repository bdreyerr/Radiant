//
//  ProfileSettingsView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/9/23.
//


// TODO: CONSIDER CREATING ONLY ONE PRESENT_EDIT ALERT, AND PASS IN THE DATA BEING CHANGED AS AN ARGUMENT EACH TIME TO ALTER THE ALERT SHOWN

import SwiftUI

struct ProfileSettingsView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    @State private var presentEditPhotoAlert = false
    
    @State private var presentEditEmailAlert = false
    @State private var oldEmail = ""
    @State private var newEmail = ""
    
    @State private var presentEditNameAlert = false
    @State private var newName = ""
    @State private var presentEditDisplayNameAlert = false
    @State private var newDisplayName = ""
    
    // Toggles for community forum
    // anon toggle
    // filter profanity toggle
    
    @State private var errorText = ""
    @State private var presentErrorAlert = false
    
    var body: some View {
        ZStack {
            Image("Profile_BG2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                List {
                    HStack(alignment: .center) {
                        
                        ZStack {
                            
                            if let profPic = profileStateManager.userProfile?.userPhotoNonPremium {
                                Image(profPic)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding(.horizontal, (UIScreen.main.bounds.width / 2))
                            } else {
                                Image("default_prof_pic")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .padding(.horizontal, (UIScreen.main.bounds.width / 2))
                            }
                                
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
                        }
                        
                        // Name
                        HStack {
                            Text("Name: ")
                                .bold()
                            if let name = profileStateManager.userProfile?.name {
                                Text(name)
                            } else {
                                Text("User")
                            }
                            
                            Button(action: {
                                presentEditNameAlert = true
                                print("User wanted to change name")
                            })
                            {
                                Image(systemName: "info.circle")
                            }
                            .alert("Edit Name", isPresented: $presentEditNameAlert) {
                                TextField("New Name", text: $newName)
                                HStack {
                                    Button("Cancel", role: .cancel) {
                                        presentEditNameAlert = false
                                    }.foregroundColor(.red)
                                    Button("Save", role: .none) {
                                        
                                        if newName != "" {
                                            if let err = profileStateManager.updateUserName(newName: newName) {
                                                print("error changing name: \(err)")
                                            } else {
                                                print("name change success")
                                            }
                                        }
                                        presentEditNameAlert = false
                                    }.foregroundColor(.blue)
                                }
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    Section(header: Text("Community Forum")) {
                        // Display Name
                        HStack {
                            Text("Display Name: ")
                                .bold()
                            if let displayName = profileStateManager.userProfile?.displayName {
                                Text(displayName)
                            } else {
                                Text("User")
                            }
                            
                            Button(action: {
                                presentEditDisplayNameAlert = true
                                print("User wanted to change display name")
                            })
                            {
                                Image(systemName: "info.circle")
                            }
                            .alert("Edit Dispaly Name", isPresented: $presentEditDisplayNameAlert) {
                                TextField("New Dispaly Name", text: $newDisplayName)
                                HStack {
                                    Button("Cancel", role: .cancel) {
                                        presentEditDisplayNameAlert = false
                                    }.foregroundColor(.red)
                                    Button("Save", role: .none) {
                                        
                                        if newDisplayName != "" {
                                            if let err = profileStateManager.updateUserDisplayName(newName: newDisplayName) {
                                                print("error changing name: \(err)")
                                            } else {
                                                print("name change success")
                                            }
                                        }
                                        presentEditDisplayNameAlert = false
                                    }.foregroundColor(.blue)
                                }
                                
                            }
                        }
                        
//                        Toggle(isOn: $profileStateManager.isForumAnon, label: {
//                            Text("Appear anonymous on the forum")
//                        })
//                        Toggle(isOn: $profileStateManager.isProfanityFiltered, label: {
//                            Text("Filter profanity")
//                        })
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
            }
        }.padding(.top, 100)
        
        
    }
}


struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}
