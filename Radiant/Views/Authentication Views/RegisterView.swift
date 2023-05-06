//
//  RegisterView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

/*
 
 ToDos:
 - Redesign the text fields in the RegisterPopUpView
 - Fix the debug messages that popup when the keyboard opens
 - Make it so the text fields move up when the keyboard opens
 
 - Add a unit test which tests this Register controller logic
 
 
 */


import SwiftUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

struct RegisterView: View {
    
    @ObservedObject var authStateManager: AuthStatusManager
    
    var body: some View {
        NavigationView() {
            ZStack {
                Image("Register_BG")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    
                    // Register with email button
                    ActionButtonView(text: "Register with email", symbolName: "envelope.fill", action: {
                        authStateManager.isRegisterPopupShowing = true
                    }).sheet(isPresented: $authStateManager.isRegisterPopupShowing) {
                        RegisterWithEmailView(authStateManager: authStateManager)
                    }
                    
                    // Already a member prompt
                    HStack{
                        Text("Already a member?").foregroundColor(.white)
                        Button(action: {
                            authStateManager.isLoginPopupShowing = true
                        }) {
                            Text("Login").foregroundColor(.cyan).underline()
                        }.sheet(isPresented: $authStateManager.isLoginPopupShowing) {
                            LoginWithEmailView(authStateManager: authStateManager)
                        }
                    }.padding(.all, 8.0)
                    
                    
                    // Register with Apple button
                    SignInWithAppleButton(
                        onRequest: { request in
                            let nonce = authStateManager.randomNonceString()
                            authStateManager.currentNonce = nonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = authStateManager.sha256(nonce)
                        },
                        onCompletion: { result in
                            authStateManager.appleSignInButtonOnCompletion(result: result)
                        }
                    ).frame(width: 350, height: 60)
                        .cornerRadius(50)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 2))
                }.padding(.bottom, 75)
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(authStateManager: AuthStatusManager())
    }
}
