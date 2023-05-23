//
//  ForumPostComment.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/23/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ForumPostComment: Codable {
    @DocumentID var id: String?
    var postID: String?
    var authorID: String?
    var date: Date?
    var content: String?
    var likeCount: Int?
}
