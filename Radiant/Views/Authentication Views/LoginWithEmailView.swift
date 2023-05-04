//
//  LoginView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import SwiftUI

struct LoginWithEmailView: View {
    
    @ObservedObject var authStateManager: AuthStatusManager
    
    
    var body: some View {
        ZStack {
            // Background Image
            Image("Login_Email_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Close popup Button
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .offset(x: 170, y: -300)
                    .onTapGesture {
                        // Dismiss the register with email popup on tap
                        authStateManager.isLoginPopupShowing = false
                    }
                    .padding(.top, 30)
                
                VStack {
                    // Email text field
                    TextField("Email", text: $authStateManager.email)
                        .foregroundColor(Color.white)
                        .cornerRadius(50)
                        .frame(maxWidth: 300)
                        .font(.system(size: 25, design: .default))
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .padding(.bottom, 15)
                        
                    // Password text fields
                    SecureField("Password", text: $authStateManager.password)
                        .foregroundColor(Color.white)
                        .cornerRadius(50)
                        .frame(maxWidth: 300)
                        .font(.system(size: 25, design: .default))
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .padding(.bottom, 15)
                    
                    // Register Button
                    Button(action: {
                        print("From popup View: The Login button on Login with email popup was pressed")
                        authStateManager.loginWithEmail()
                        print("Testing async order")
                    }) {
                        Text("Login").foregroundColor(.white).font(.system(size: 20)).underline()
                    }
                }.offset(y: 80)
                
            }
        }
    }
}

struct LoginWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        LoginWithEmailView(authStateManager: AuthStatusManager())
    }
}
