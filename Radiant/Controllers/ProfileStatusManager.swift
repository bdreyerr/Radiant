//
//  ProfileStatusManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/9/23.
//


import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class ProfileStatusManager: ObservableObject {
    
    // Bool var controlling the settings popup
    @Published var isProfileSettingsPopupShowing: Bool = false
    
    // Rate limiting
    @Published var numActionsInLastMinute: Int = 0
    @Published var firstActionDate: Date?
    @Published var lastActionDate: Date?
    
    // Firestore
    let db = Firestore.firestore()
    @Published var userProfile: UserProfile?
    
    //    init() {
    //
    //        if let userID = Auth.auth().currentUser?.uid {
    //            self.retrieveUserProfile(userID: userID)
    //            if let user = self.userProfile {
    //                self.generateAnonUsernameForForum()
    //            } else {
    //                print("User didn't save into ProfileStateManager")
    //            }
    //
    //        }
    //    }
    
    
    func retrieveUserProfile(userID: String) {
        let docRef = db.collection(Constants.FStore.usersCollectionName).document(userID)
        
        docRef.getDocument(as: UserProfile.self) { result in
            switch result {
            case .success(let userProf):
                // A UserProfile value was successfully initalized from the DocumentSnapshot
                self.userProfile = userProf
//                print("Successfully retrieved the user profile stored in Firestore. Access it with profileStatusManager.userProfile")
                
            case .failure(let error):
                // A UserProfile value could not be initialized from the DocumentSnapshot
//                print("Failure retrieving the user profile from firestore: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func updateUserProfileEmail(newEmail: String) -> String? {
        var errorText: String?
        
        if let user = userProfile {
            // We can assume if the user exists they have an ID
            let docRef = db.collection(Constants.FStore.usersCollectionName).document(user.id!)
            
            // Before we set the new emails, make sure they are valid email addresses
            userProfile?.email = newEmail
            userProfile?.displayName = newEmail
            do {
                try docRef.setData(from: userProfile)
            } catch {
                errorText = error.localizedDescription
            }
        }
        return errorText
    }
    
    func updateUserName(newName: String) -> String? {
        var errorText: String?
        
        if let user = userProfile {
            if newName.count > 50 {
                return "name too long"
            }
            
            let docRef = db.collection(Constants.FStore.usersCollectionName).document(user.id!)
            
            userProfile?.name = newName
            do {
                try docRef.setData(from: userProfile)
            } catch {
                errorText = error.localizedDescription
            }
        }
        return errorText
    }
    
    func updateUserDisplayName(newName: String) -> String? {
        var errorText: String?
        
        if let user = userProfile {
            
            if newName.count > 50 {
                return "name too long"
            }
            
            let docRef = db.collection(Constants.FStore.usersCollectionName).document(user.id!)
            
            userProfile?.displayName = newName
            do {
                try docRef.setData(from: userProfile)
            } catch {
                errorText = error.localizedDescription
            }
        }
        return errorText
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        // Regular expression to validate email addresses
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        // Create a regular expression object
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        // Return true if the email address is valid
        return emailTest.evaluate(with: emailAddressString)
    }
    
    func processFirestoreWrite() -> String? {
        var errorText: String?
        
        // if firstAction Date Exists
        if let firstD = self.firstActionDate {
            
            let oneMinFromFirst = firstD + 60
            
            // if last action date is within one minute of first action date
            if self.lastActionDate! <= oneMinFromFirst {
                // num actions within 1 minute greater than 5
                if self.numActionsInLastMinute >= 5 {
                    errorText = "Too many actions in one minute"
                } else {
                    // num actions within one minute less than 5
                    self.lastActionDate = Date()
                    self.numActionsInLastMinute += 1
                }
            } else {
                // Last action date after 1 miute from first action date
                self.firstActionDate = Date()
                self.lastActionDate = Date()
                self.numActionsInLastMinute = 1
            }
            
        } else {
            // First action date doesn't exist
            self.firstActionDate = Date()
            self.lastActionDate = Date()
            self.numActionsInLastMinute = 1
        }
        
        return errorText
    }
}
