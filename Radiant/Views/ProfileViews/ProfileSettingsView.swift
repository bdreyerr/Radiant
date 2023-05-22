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
    
    @State private var presentEditBirthdayAlert = false
    @State private var presentEditWeightAlert = false
    @State private var presentEditHeightAlert = false
    @State private var presentEditDisplayNameAlert = false
    
    // Toggles for community forum
    // anon toggle
    // filter profanity toggle
    
    @State private var errorText = ""
    @State private var presentErrorAlert = false
    
    var body: some View {
        ZStack {
            Image("Profile_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                
                List {
                    HStack(alignment: .center) {
                        
                        ZStack {
                            
                            Image("default_prof_pic")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .padding(.horizontal, (UIScreen.main.bounds.width / 2))
                            
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.teal)
                                .padding(.leading, 70)
                                .padding(.bottom, 50)
                            
                            
                            Button(action: {
                                print("change image button pressed")
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .padding(.leading, 70)
                                    .padding(.bottom, 50)
                                    .foregroundColor(.black)
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
                            
                            Button(action: {
                                presentEditEmailAlert = true
                                print("User wanted to change email")
                            })
                            {
                                Image(systemName: "info.circle")
                            }
                            .alert("Edit Email", isPresented: $presentEditEmailAlert) {
                                TextField("Current Email", text: $oldEmail)
                                TextField("New Email", text: $newEmail)
                                HStack {
                                    Button("Cancel", role: .cancel) {
                                        presentEditEmailAlert = false
                                    }.foregroundColor(.red)
                                    Button("Save", role: .none) {
                                        // if the entered old email = the user's current email
                                        
                                        // testing current email and current email input by user
                                        print("Current email on authStateManager: \(authStateManager.email)")
                                        print("Current email on profileStateManager: \(profileStateManager.userProfile?.email ?? "default email")")
                                        print("Current email input by user: \(oldEmail)")
                                        
                                        if oldEmail == authStateManager.email && oldEmail == profileStateManager.userProfile?.email {
                                            if profileStateManager.isValidEmailAddress(emailAddressString: newEmail) {
                                                // Update the user's info in the 'users' collection in Firestore
                                                if let user = profileStateManager.userProfile {
                                                    if let error = profileStateManager.updateUserProfileEmail(newEmail: newEmail) {
                                                        errorText = error
                                                        presentErrorAlert = true
                                                    } else {
                                                        print("Email updated on the profileStateManager.userProfile")
                                                    }
                                                }
                                                
                                                // Update the user's auth email stored in the Auth table in Firebase
                                                if let e = authStateManager.updateAuthEmail(newEmail: newEmail) {
//                                                    print("ERROR UPDATING EMAIL IN AUTH TABLE: \(e)")
                                                    errorText = e
                                                    presentErrorAlert = true
                                                } else {
                                                    print("UPDATING EMAIL WAS SUCCESSFUL")
                                                }
                                            } else {
//                                                print("The new email address is not a valid email")
                                                errorText = "The new email address is not a valid email"
                                                presentErrorAlert = true
                                            }
                                        } else {
                                            errorText = "Please enter the correct current email address"
                                            presentErrorAlert = true
                                        }
                                        presentEditEmailAlert = false
                                    }.foregroundColor(.blue)
                                }
                                
                            }
                            .alert("\(errorText)", isPresented: $presentErrorAlert) {
                                Button("OK", role: .none) {
                                    print(errorText)
                                    presentErrorAlert = false
                                }
                            }
                            
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
