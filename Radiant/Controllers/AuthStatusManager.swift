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
import FirebaseFirestore


class AuthStatusManager: ObservableObject {
    // This variable tracks whether or not the user will encounter the login / register screens
    @Published var isLoggedIn: Bool = false
    
    // These vars are used for registering / logging in the user with email and password
    @Published var email = ""
    @Published var password = ""
    
    // Variables used for the closed beta
    @Published var betaCode = ""
    @Published var isBetaCodeValid: Bool = false
    
    // Variables used for the welcome survey
    @Published var name: String = ""
    @Published var birthday: Date = Date()
    @Published var displayName: String = ""
    @Published var hasUserCompletedSurvey: Bool = false
    
    
    // Error text used to display to the user (Email already in use, password not secure enough, etc...)
    @Published private var errorText: String?
    
    // These vars are used for controlling the Auth popups
    @Published var isRegisterPopupShowing: Bool = false
    @Published var isLoginPopupShowing: Bool = false
    
    // Unhashed nonce. (used for Apple sign in)
    @Published var currentNonce:String?
    
    // Firestore
    let db = Firestore.firestore()
    //    @Published var userProfile: UserProfile?
    
    
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
            
            // Retrieved the user profile from Firestore and store it in this class' userProfile var
            //            if let userID = Auth.auth().currentUser?.uid {
            //                strongSelf.retrieveUserProfile(userID: userID)
            //            } else {
            //                print("The current user could not be retrieved")
            ////                authStateManager.logOut()
            //            }
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
            
            // Set beta status as false after register before user enters their code
            print("setting the user default for the beta as false")
            UserDefaults.standard.set(false, forKey: isUserValidForBetaKey)
            
            // Set the user default for the user completing the welcome survey to false, they will complete it after register
            print("setting the user default for the welcome survey as false")
            UserDefaults.standard.set(false, forKey: hasUserCompletedWelcomeSurveyKey)
            
            // Create the user profile in Firestore
            let userProf = UserProfile(email: self.email, displayName: self.email, anonDisplayName: nil, birthday: nil, weight: nil, height: nil, goals: nil)
            let collectionRef = self.db.collection(Constants.FStore.usersCollectionName)
            do {
                try collectionRef.document(user.uid).setData(from: userProf)
                print("User stored with new user reference: \(user.uid)")
            } catch {
                print("Error saving user to firestore: \(error.localizedDescription)")
            }
            
            // Retrieve the user profile from Firestore and store it in this class' userProfile var
            //            if let userID = Auth.auth().currentUser?.uid {
            //                self.retrieveUserProfile(userID: userID)
            //            } else {
            //                print("The current user could not be retrieved")
            ////                authStateManager.logOut()
            //            }
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
                    
                    guard let user = authResult?.user else {
                        print("No user")
                        return
                    }
                    
                    print("signed in with apple")
                    print("\(String(describing: user.uid))")
                    // Careful about saving the email into UserDefaults because the user may choose to hide email address from the app with sign in
                    if let email = user.email {
                        self.email = email
                        UserDefaults.standard.set(self.email, forKey: emailKey)
                    }
                    self.isLoggedIn = true
                    self.isRegisterPopupShowing = false
                    
                    // Set user defaults
                    UserDefaults.standard.set(self.isLoggedIn, forKey: loginStatusKey)
                    
                    // Set beta status as false after register before user enters their code
                    print("setting the user default for the beta as false")
                    UserDefaults.standard.set(false, forKey: isUserValidForBetaKey)
                    
                    // Set the user default for the user completing the welcome survey to false, they will complete it after register
                    print("setting the user default for the welcome survey as false")
                    UserDefaults.standard.set(false, forKey: hasUserCompletedWelcomeSurveyKey)
                    
                    // Create the user profile in Firestore
                    let userProf = UserProfile(email: self.email, displayName: self.email, birthday: nil, weight: nil, height: nil, goals: nil)
                    let collectionRef = self.db.collection(Constants.FStore.usersCollectionName)
                    do {
                        try collectionRef.document(user.uid).setData(from: userProf)
                        print("Apple sign in user stored with new user reference: \(user.uid)")
                    } catch {
                        print("Error saving user to firestore: \(error.localizedDescription)")
                    }
                    
                    // Retrieved the user profile from Firestore and store it in this class' userProfile var
                    //                    if let userID = Auth.auth().currentUser?.uid {
                    //                        self.retrieveUserProfile(userID: userID)
                    //                    } else {
                    //                        print("The current user could not be retrieved")
                    //        //                authStateManager.logOut()
                    //                    }
                }
            default:
                break
            }
        default:
            break
        }
    }
    
    // Update a user's email address stored in the auth table (as long as they didn't sign in with apple)
    // We don't need to pass in a the newEmail as a argument, because the changing email is tied to the text field on the edit email popup
    func updateAuthEmail(newEmail: String) -> String? {
        var returnError: String?
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: newEmail) { error in
                if let e = error {
                    // TEMPORARY FIX: WHEN THE USER IS REQUIRED TO REAUTHENTICATE BY FIREBASE, SIMPLY JUST LOG THEM OUT. IN THE FUTURE, WE NEED TO ASK FOR THEIR LOGIN CREDENTIALS AGAIN AND REAUTHENTICATE BEFORE THEY CAN CHANGE THEIR EMAIL
                    print("There was an error updating the user's email: \(e.localizedDescription)")
                    returnError = e.localizedDescription
                    
                    //                    self.logOut()
                } else {
                    print("Successfully updated user email in the auth table, no error.")
                    self.email = newEmail
                    print("Email updated on authStateManager: \(self.email)")
                }
            }
        }
        if returnError != nil {
            return returnError
        } else {
            return nil
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
        
        self.isBetaCodeValid = false
        UserDefaults.standard.set(self.isBetaCodeValid, forKey: isUserValidForBetaKey)
        
        self.hasUserCompletedSurvey = false
        UserDefaults.standard.set(self.hasUserCompletedSurvey, forKey: hasUserCompletedWelcomeSurveyKey)
        
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
    
    func addBetaCodes() {
        let codes = [""]
        
        // Add the beta codes to firebase
        for code in codes {
            print("adding beta code \(code) to firebase")
            db.collection("betaCodes").document(code).setData([
                "code": code,
                "isCodeUsed": false,
            ]) { err in
                if let err = err {
                    print("Error adding code: \(err)")
                } else {
                    print("Beta code successfully written!")
                }
            }
        }
    }
    
    // Check if a user's beta code is valid, allowing them to continue to the app
    func checkBetaCode(code: String, user: String) {
        // check if the code exists in the db
        let docRef = db.collection("betaCodes").document(code)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                if let isCodeUsed = document.data()!["isCodeUsed"] as? Bool {
                    if isCodeUsed == false {
                        self.isBetaCodeValid = true
                        UserDefaults.standard.set(self.isBetaCodeValid, forKey: isUserValidForBetaKey)
                        
                        // Mark the beta code as being used
                        docRef.setData([
                            "code": code,
                            "isCodeUsed": true,
                            "usedBy": user,
                        ])
                        
                    } else {
                        print("Beta code has already been used")
                        
                        if let usedBy = document.data()!["usedBy"] as? String {
                            if usedBy == user {
                                self.isBetaCodeValid = true
                                UserDefaults.standard.set(self.isBetaCodeValid, forKey: isUserValidForBetaKey)
                            }
                        }
                    }
                }
                
            } else {
                print("Beta code is not valid")
            }
        }
    }
    
    // Complete the welcome survey
    func completeWelcomeSurvey(user: String) {
        // update the user's firestore document with name, birthday, displayName and aspirations
        db.collection("users").document(user).updateData([
            "name": self.name,
            "birthday": self.birthday,
            "displayName": self.displayName
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                // Set user default for completing the welcome survey to true
                self.hasUserCompletedSurvey = true
                UserDefaults.standard.set(self.hasUserCompletedSurvey, forKey: hasUserCompletedWelcomeSurveyKey)
            }
        }
    }
    
}
