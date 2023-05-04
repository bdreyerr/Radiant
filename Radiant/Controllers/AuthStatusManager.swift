//
//  AuthStatusManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/4/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth


class AuthStatusManager: ObservableObject {
    // This variable tracks whether or not the user will encounter the login / register screens
    @Published var isLoggedIn: Bool = false
    
    // These vars are used for registering / logging in the user with email and password
    @Published var email = ""
    @Published var password = ""
    
    @Published private var errorText: String?
    
    // These vars are used for controlling the Auth popups
    @Published var isRegisterPopupShowing: Bool = false
    @Published var isLoginPopupShowing: Bool = false
    
    
    // Log the user in with email and password
    func loginWithEmail() {
        print("The user logged in with email and password")
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let e = error {
                print("Issue when trying to login: \(e.localizedDescription)")
            }
            
            guard let strongSelf = self else {
                return
            }
            
            guard let user = authResult?.user else {
                print("No user")
                return
            }
            
            
            print("User was logged in as user, \(user.uid), with email: \(user.email ?? "no email")")
            strongSelf.isLoggedIn = true
            strongSelf.isLoginPopupShowing = false
        }
    }
    
    // Register the user with email and password
    func registerWithEmail() {
        print("User wanted to register with email and password")
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print("There was an issue when trying to register: \(e.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                print("No user")
                return
            }
            
            print("User was registered as user, \(user.uid) with email \(user.email ?? "email null")")
            self.isLoggedIn = true
            self.isRegisterPopupShowing = false
        }
    }
    
    // Sign the user in with Apple account
    func signInWithApple() {
        print("The user tried to log in with their Apple account")
    }
    
}
