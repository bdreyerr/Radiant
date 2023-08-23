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
            Image("Profile_BG2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        authStateManager.logOut()
                    }) {
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.red)
                            .frame(width: 90, height: 50)
                            .overlay {
                                Text("Log Out")
                                    .foregroundColor(.black)
                                    .font(.system(size: 14, design: .serif))
                            }
                    }.padding(.leading, 20)
                    
                    Spacer()
                    

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
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 40)
                
                HStack {
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
                    
                    
                    if let name = profileStateManager.userProfile?.name {
                        Text(name)
                            .foregroundColor(.white)
                            .font(.system(size: 20, design: .serif))
                    } else {
                        Text("User")
                            .padding(.trailing, 30)
                            .foregroundColor(.white)
                            .font(.system(size: 20, design: .serif))
                    }
                }
                .padding(.bottom, 20)
                
                
                VStack {
                    if let displayName = profileStateManager.userProfile?.displayName {
                        Text(displayName)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .font(.system(size: 20, design: .serif))
                    } else {
                        Text("Display Name")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .font(.system(size: 20, design: .serif))
                    }
                }
                .padding(.bottom, 40)
                
                VStack {
                    if let email = profileStateManager.userProfile?.email {
                        Text(email)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .font(.system(size: 20, design: .serif))
                    } else {
                        Text("placeholder@email.com")
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .font(.system(size: 20, design: .serif))
                    }
                }
                .padding(.bottom, 40)
                
                
                VStack {
                    
                    HStack {
                        Text("Current Plan")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 20, design: .serif))
                        
                        Text("Basic")
                            .foregroundColor(.white)
                            .font(.system(size: 18, design: .serif))
                        
                        Button(action: {
                            //                            authStateManager.logOut()
                        }) {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundColor(.blue)
                                .frame(width: 120, height: 40)
                                .overlay {
                                    Text("Change Plan")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16, design: .serif))
                                }
                            
                        }
                        .padding(.trailing, 20)
                        .padding(.leading, 20)
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
