//
//  ForumPost.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/23/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ForumPost: Codable, Identifiable {
//    @DocumentID var id: String?
    var id: String?
    var authorID: String?
    var category: String?
    var date: Date?
    var content: String?
    var likeCount: Int?
    var reportCount: Int?
}
