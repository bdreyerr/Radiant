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
    let email: String?
    let displayName: String?
    let birthday: Date?
    let weight: Int?
    let height: Double?
    let goals: [String]? // Figure out how to store this based on preset goals I define for the user
}
