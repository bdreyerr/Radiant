//
//  UserProfile.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/7/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


struct UserProfile: Codable {
    @DocumentID var id: String?
    var email: String?
    var name: String?
    var displayName: String?
    var anonDisplayName: String?
    var birthday: Date?
    var weight: Int?
    var height: Double?
    var userPhotoNonPremium: String?
    
    var lastCheckinDate: String?
    var checkIns: [String: CheckIn]?
}
