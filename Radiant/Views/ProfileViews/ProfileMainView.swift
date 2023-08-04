//
//  ProfileMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/6/23.
//

import SwiftUI

struct ProfileMainView: View {
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    
    var body: some View {
        
        ZStack {
            Image("Profile_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        authStateManager.logOut()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                    }
                    .padding(.trailing, 190)
                    .foregroundColor(.white)
                    
//                    Image(systemName: "gearshape")
//                        .resizable()
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(.white)
                    Button(action: {
                        profileStateManager.isProfileSettingsPopupShowing = true
                    }) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                    }.sheet(isPresented: $profileStateManager.isProfileSettingsPopupShowing) {
                        ProfileSettingsView()
                    }
                    
                    
//                    .sheet(isPresented: $profileStateManager.isProfileSettingsPopupShowing) {
////                        RegisterWithEmailView(authStateManager: authStateManager)
//                        // ProfileSettingsView(authStateManager: authStateManager, profileStateManager: profileStateManager)
//                    }
                    
                }.padding(.bottom, 40)
                
                HStack(alignment: .center, spacing: 10) {
                    if let profPic = profileStateManager.userProfile?.userPhotoNonPremium {
                        Image(profPic)
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(.trailing, 30)
                    } else {
                        Image("default_prof_pic")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(.trailing, 30)
                    }
                    
                    
                    if let displayName = profileStateManager.userProfile?.displayName {
                        if profileStateManager.isForumAnon == true {
                            let anonDisplayName = profileStateManager.userProfile?.anonDisplayName
                            Text(anonDisplayName!)
                                .padding(.trailing, 30)
                                .foregroundColor(.white)
                        } else {
                            Text(displayName)
                                .padding(.trailing, 30)
                                .foregroundColor(.white)
                        }
                    } else {
                        Text("Display name here")
                            .padding(.trailing, 30)
                            .foregroundColor(.white)
                            .font(Font.custom("RalewayRoman-Regular", size: 20))
                    }
                }
                
                Divider()
                    .overlay(Rectangle().fill(Color.white).frame(height: 1))
                    .frame(width: 0.8 * UIScreen.main.bounds.width)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                
                VStack {
                    Text("Email")
                        .frame(alignment: .leading)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, 10)
                    if let email = profileStateManager.userProfile?.email {
                        Text(email)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 40)
                    } else {
                        Text("placeholder@email.com")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 40)
                    }
                }
                
                Divider()
                    .overlay(Rectangle().fill(Color.white).frame(height: 1))
                    .frame(width: 0.8 * UIScreen.main.bounds.width)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                VStack {
                    Text("Info")
                        .frame(alignment: .leading)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("Birthday")
                            .foregroundColor(.white)
                            .bold()
                        
                        if let birthday = profileStateManager.userProfile?.birthday {
                            Text(birthday, style: .date)
                                .foregroundColor(.white)
                        } else {
                            Text(Date.now, style: .date)
                                .foregroundColor(.white)
                            
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("Weight")
                            .foregroundColor(.white)
                            .bold()
                        
                        if let weight = profileStateManager.userProfile?.weight {
                            Text("\(weight)kg")
                                .foregroundColor(.white)
                        } else {
                            Text("68kg")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("Height")
                            .foregroundColor(.white)
                            .bold()
                        
                        if let height = profileStateManager.userProfile?.height {
                            Text("\(height)m")
                                .foregroundColor(.white)
                        } else {
                            Text("1.3m")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.bottom, 20)
                    
                }
                
                Divider()
                    .overlay(Rectangle().fill(Color.white).frame(height: 1))
                    .frame(width: 0.8 * UIScreen.main.bounds.width)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                VStack {
                    Text("Subscription")
                        .frame(alignment: .leading)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("Current Plan")
                            .foregroundColor(.white)
                            .bold()
                        
                        Text("Basic")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            //                            authStateManager.logOut()
                        }) {
                            Text("Change Plan")
                                .foregroundColor(.cyan)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.cyan, lineWidth: 2)
                                )
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 50)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 40)
                    .padding(.bottom, 20)
                }
                
                
                Spacer()
            }.padding(.top, 75)
            
            
            
        }
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView()
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
    }
}
