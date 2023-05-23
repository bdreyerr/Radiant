//
//  ForumManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/23/23.
//

import Foundation
import AuthenticationServices
import CryptoKit
import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class ForumManager: ObservableObject {
    
    // Info needed to save a post
    @Published var authorID = ""
    @Published var category = ""
    @Published var content = ""
    
    
    // Firestore
    let db = Firestore.firestore()
    
    
    // This function retrieves the posts of a certain category when the user opens that category's page
    // TODO: Find a way to limit the number of posts loaded, and load more when the user scrolls down
    func retrievePosts() -> [Post]? {
        
        
        return nil
    }
    
    func publishPost() {
        print("User wanted to publish a post")
        
        let postID = UUID()
        
        // Create the Post Object and save it to the corresponding firestore collection
        let post = ForumPost(authorID: self.authorID, category: self.category, date: Date.now, content: self.content, likeCount: 1, comments: [])
        var collectionRef: CollectionReference
        switch post.category {
        case "General":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameGeneral)
        case "Depression":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameDepression)
        case "Stress and Anxiety":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameStressAnxiety)
        case "Relationships":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameRelationships)
        case "Recovery":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameRecovery)
        case "Addiction":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameAddiction)
        case "Sobriety":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameSobriety)
        case "Personal Stories":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNamePersonalStories)
        case "Advice":
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameAdvice)
        default:
            collectionRef = self.db.collection(Constants.FStore.forumCollectionNameGeneral)
        }
        
        do {
            try collectionRef.document().setData(from: post)
            print("Post stored with reference id: \(post.id ?? "No post id generated")")
        } catch {
            print("Error saving post to firestore: ")
        }
        
    }
    
    func publishComment() {
        print("User wanted to publish a comment on a post")
    }
}
