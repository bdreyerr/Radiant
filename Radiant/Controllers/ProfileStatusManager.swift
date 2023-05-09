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
    
    // Comunity Forum vars
    @Published var isForumAnon: Bool = true
    @Published var isProfanityFiltered: Bool = true
    
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
                print("Successfully retrieved the user profile stored in Firestore. Access it with profileStatusManager.userProfile")
                self.generateAnonUsernameForForum()
                
            case .failure(let error):
                // A UserProfile value could not be initialized from the DocumentSnapshot
                print("Failure retrieving the user profile from firestore: \(error.localizedDescription)")
            }
        }
    }
    
    
    func generateAnonUsernameForForum(numWords: Int = 150) {
        let words = ["apple", "banana", "cat", "dog", "elephant", "fish", "goat", "horse", "iguana", "jellyfish",
                      "key", "lemon", "monkey", "noodle", "orange", "pen", "queen", "rabbit", "snake", "turtle",
                      "umbrella", "violin", "watermelon", "xylophone", "yacht", "zebra"]
        
        let word1 = words.randomElement()!
        let word2 = words.randomElement()!
        let number = Int.random(in: 1...100)
        
        print(word1 + "_" + word2 + String(number))
        userProfile?.anonDisplayName = word1 + "_" + word2 + String(number)
    }
}
