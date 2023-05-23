//
//  Constants.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import Foundation


struct Constants {
    static let appName = "Radiant"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct FStore {
        static let usersCollectionName = "users"
        static let userField = "user"
        static let bodyField = "body"
        static let dateField = "date"
        
        // Forum collection names
        static let forumCollectionNameGeneral = "forumGeneral"
        static let forumCollectionNameDepression = "forumDepression"
        static let forumCollectionNameStressAnxiety = "forumStressAnxiety"
        static let forumCollectionNameRelationships = "forumRelationships"
        static let forumCollectionNameRecovery = "forumRecovery"
        static let forumCollectionNameAddiction = "forumAddiction"
        static let forumCollectionNameSobriety = "forumSobriety"
        static let forumCollectionNamePersonalStories = "forumPersonalStories"
        static let forumCollectionNameAdvice = "forumAdvice"
    }
    
    struct AppleIDs {
        static let appleSignInServiceID = "com.bendreyer.radiant-applesigninid"
        static let appleSignInPrivateKeyName = "RadiantAppleSignInKey"
        static let appleSignInPrivateKeyID = "J4A348M8W5"
    }
    
    struct UserDefaults {
        static let emailKey = "emailKey"
        static let userLoggedInKey = "userLoggedInKey"
    }
}
