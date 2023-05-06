//
//  AuthStatusManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/4/23.
//

import AuthenticationServices
import CryptoKit
import Foundation
import FirebaseCore
import FirebaseAuth


class AuthStatusManager: ObservableObject {
    // This variable tracks whether or not the user will encounter the login / register screens
    @Published var isLoggedIn: Bool = false
    
    // These vars are used for registering / logging in the user with email and password
    @Published var email = ""
    @Published var password = ""
    
    // Error text used to display to the user (Email already in use, password not secure enough, etc...)
    @Published private var errorText: String?
    
    // These vars are used for controlling the Auth popups
    @Published var isRegisterPopupShowing: Bool = false
    @Published var isLoginPopupShowing: Bool = false
    
    // Unhashed nonce. (used for Apple sign in)
    @Published var currentNonce:String?
    
    
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
            UserDefaults.standard.set(strongSelf.email, forKey: emailKey)
            UserDefaults.standard.set(strongSelf.isLoggedIn, forKey: loginStatusKey)
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
            
            // Set user defaults to keep the user logged in
            UserDefaults.standard.set(self.email, forKey: emailKey)
            UserDefaults.standard.set(self.isLoggedIn, forKey: loginStatusKey)
        }
    }
    
    // The function called in the onComplete closure of the SignInWithAppleButton in the RegisterView
    func appleSignInButtonOnCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if (error != nil) {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error?.localizedDescription as Any)
                        return
                    }
                    print("signed in with apple")
                }
                
                print("\(String(describing: Auth.auth().currentUser?.uid))")
                self.isLoggedIn = true
                self.isRegisterPopupShowing = false
                // Don't save the email into UserDefaults because they user may choose to hide email address from the app with sign in
                // UserDefaults.standard.set(self.email, forKey: emailKey)
                UserDefaults.standard.set(self.isLoggedIn, forKey: loginStatusKey)
                
            default:
                break
                
            }
        default:
            break
        }
    }
    
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
            return
        }
        self.isLoggedIn = false
        UserDefaults.standard.set(isLoggedIn, forKey: loginStatusKey)
        print("The user logged out")
    }
    
    
    // Functions for apple sign in flow
    
    // Generate a random Nonce used to make sure the ID token you get was granted specifically in response to your app's authentication request.
    //Hashing function using CryptoKit
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // from https://firebase.google.com/docs/auth/ios/apple
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
}
