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
import FirebaseFirestoreSwift


class ForumManager: ObservableObject {
        
//    var posts: [ForumPost] = []
    
    @Published var isCreatePostPopupShowing: Bool = false
    @Published var isCreateCommentPopupShowing: Bool = false
    
    @Published var isReportPostAlertShowing: Bool = false
    
    // Firestore
    let db = Firestore.firestore()
    
    @Published var focusedPostID: String = ""
    @Published var focusedPostCategoryName: String = ""
    @Published var isFocusedPostLikedByCurrentUser: Bool = false
    
    
    // This function retrieves the posts of a certain category when the user opens that category's page
    // TODO: Find a way to limit the number of posts loaded, and load more when the user scrolls down
//    func retrievePosts(postCategory: String) -> [ForumPost]{
//
//        var posts: [ForumPost] = []
//        let collectionName = getFstoreForumCategoryCollectionReference(category: postCategory)
//
//        posts = await retrievePostsfromFStore(collectionName: collectionName)
//
//        return posts
//    }
    
//    func retrievePosts(postsInView: inout [ForumPost], category: String) {
//        let collectionName = getFstoreForumCategoryCollectionName(category: category)
//        let collectionRef = db.collection(collectionName)
//
//        var posts: [ForumPost] = []
//
//        postsInView = []
//
//        collectionRef.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Erorr retrieving forum posts from firestore: \(err.localizedDescription)")
//            } else if let querySnapshot = querySnapshot {
//                for document in querySnapshot.documents {
//                    let post = ForumPost(
//                        id: document.documentID, authorID: document.data()["authorID"] as? String,
//                            category: document.data()["category"] as? String,
//                            date: document.data()["date"] as? Date,
//                            content: document.data()["content"] as? String,
//                            likeCount: document.data()["likeCount"] as? Int)
//                    posts.append(post)
//                }
//            }
//        }
//
//        for post in posts {
//            postsInView.append(post)
//        }
//
//    }
    
    
    func publishPost(authorID: String, category: String, content: String) {
        print("User wanted to publish a post")
        
        // Create the Post Object and save it to the corresponding firestore collection
        let post = ForumPost(authorID: authorID, category: category, date: Date.now, content: content, reportCount: 0, likes: [authorID])
        // TODO: Add if let category = post.category to make sure the post has a corresponding cateogry to post to
        
        let collectionName = getFstoreForumCategoryCollectionName(category: category)
        
        var ref: DocumentReference? = nil
        do {
            try ref = db.collection(collectionName).addDocument(from: post)
            print("Adding document was successful, documentID: \(ref!.documentID)")
            isCreatePostPopupShowing = false
        } catch {
            print("error adding post to collection")
        }
    }
    
    func likePost(postID: String, postCategory: String, userID: String) {
        
        print("User: \(userID) wanted to like a post: \(postID)")
        
        let collectionName = getFstoreForumCategoryCollectionName(category: postCategory)
        let documentRef = db.collection(collectionName).document(postID)
        
        documentRef.updateData([
            "likes": FieldValue.arrayUnion([userID])
        ]) { err in
            if let err = err {
                print("error liking the post: \(err.localizedDescription)")
            } else {
                print("user sucessfully liked the post")
            }
        }
    }
    
    func removeLikeFromPost(postID: String, postCategory: String, userID: String) {
        print("user wanted to remove their like from the post")
        
        let collectionName = getFstoreForumCategoryCollectionName(category: postCategory)
        let documentRef = db.collection(collectionName).document(postID)
        
        documentRef.updateData([
            "likes": FieldValue.arrayRemove([userID])
        ]) { err in
            if let err = err {
                print("error liking the post: \(err.localizedDescription)")
            } else {
                print("user sucessfully liked the post")
            }
        }
    }
    
    func publishComment(authorID: String, category: String, postID: String, content: String) {
        print("User wanted to publish a comment on a post")
        
        let comment = ForumPostComment(postID: postID, authorID: authorID, date: Date.now, commentCategory: category, content: content, likes: [authorID], isCommentLikedByCurrentUser: nil)
        let collectionName = getFstoreForumCommentsCategoryCollectionName(category: category)
        
        var ref: DocumentReference? = nil
        do {
            try ref = db.collection(collectionName).addDocument(from: comment)
            print("Adding comment was successful, commentID: \(ref!.documentID) saved on postID: \(postID)")
        } catch {
            print("Error adding comment to the post")
        }
    }
    
    func likeComment(commentID: String, commentCategory: String, userID: String) {
        print("User: \(userID) wanted to like a comment: \(commentID)")
        
        let collectionName = getFstoreForumCommentsCategoryCollectionName(category: commentCategory)
        let documentRef = db.collection(collectionName).document(commentID)
        
        documentRef.updateData([
            "likes": FieldValue.arrayUnion([userID])
        ]) { err in
            if let err = err {
                print("error liking the post: \(err.localizedDescription)")
            } else {
                print("user sucessfully liked the post")
            }
        }
    }
    
    func removeLikeFromComment(commentID: String, commentCategory: String, userID: String) {
        print("user wanted to remove their like from the comment")
        
        let collectionName = getFstoreForumCommentsCategoryCollectionName(category: commentCategory)
        let documentRef = db.collection(collectionName).document(commentID)
        
        documentRef.updateData([
            "likes": FieldValue.arrayRemove([userID])
        ]) { err in
            if let err = err {
                print("error liking the post: \(err.localizedDescription)")
            } else {
                print("user sucessfully liked the post")
            }
        }
    }
    
    // Get the constant name of each FStore forum collection
    func getFstoreForumCommentsCategoryCollectionName(category: String) -> String {
        
        var categoryName: String
        
        switch category {
        case "General":
            categoryName = Constants.FStore.commentsCollectionNameGeneral
        case "Depression":
            categoryName = Constants.FStore.commentsCollectionNameDepression
        case "Stress and Anxiety":
            categoryName = Constants.FStore.commentsCollectionNameStressAnxiety
        case "Relationships":
            categoryName = Constants.FStore.commentsCollectionNameRelationships
        case "Recovery":
            categoryName = Constants.FStore.commentsCollectionNameRecovery
        case "Addiction":
            categoryName = Constants.FStore.commentsCollectionNameAddiction
        case "Sobriety":
            categoryName = Constants.FStore.commentsCollectionNameSobriety
        case "Personal Stories":
            categoryName = Constants.FStore.commentsCollectionNamePersonalStories
        case "Advice":
            categoryName = Constants.FStore.commentsCollectionNameAdvice
        default:
            categoryName = Constants.FStore.commentsCollectionNameGeneral
        }
        
        return categoryName
    }
    
    // getFstoreForumCategoryCollectionName
    // getFstoreForumCommentsCategoryCollectionName
    
    // Get the constant name of each FStore forum comments collection
    func getFstoreForumCategoryCollectionName(category: String) -> String {
        
        var categoryName: String
        
        switch category {
        case "General":
            categoryName = Constants.FStore.forumCollectionNameGeneral
        case "Depression":
            categoryName = Constants.FStore.forumCollectionNameDepression
        case "Stress and Anxiety":
            categoryName = Constants.FStore.forumCollectionNameStressAnxiety
        case "Relationships":
            categoryName = Constants.FStore.forumCollectionNameRelationships
        case "Recovery":
            categoryName = Constants.FStore.forumCollectionNameRecovery
        case "Addiction":
            categoryName = Constants.FStore.forumCollectionNameAddiction
        case "Sobriety":
            categoryName = Constants.FStore.forumCollectionNameSobriety
        case "Personal Stories":
            categoryName = Constants.FStore.forumCollectionNamePersonalStories
        case "Advice":
            categoryName = Constants.FStore.forumCollectionNameAdvice
        default:
            categoryName = Constants.FStore.forumCollectionNameGeneral
        }
        
        return categoryName
    }
    
    func reportForumPost(reasonForReport: Int) {
//        let reasonsForReport = ["Offensive", "Harmful or Dangerous", "Off Topic or Irrelevant", "Spam or Advertisment"]
        
        let documentRef = db.collection(getFstoreForumCategoryCollectionName(category: self.focusedPostCategoryName)).document(self.focusedPostID)
        
        print("The post being reported: \(self.focusedPostID)")
        
        let field = "reportCount"
        documentRef.updateData([
            field: FieldValue.increment(Int64(1))
        ]) { err in
            if let err = err {
                print("There was an error updating the reportCount \(err.localizedDescription)")
            } else {
                print("Report count updated successfully")
            }
        }
    }
    
//    func retrievePostsfromFStore(collectionName: String) async -> [ForumPost] {
//        var posts: [ForumPost] = []
//
//        let collectionRef = db.collection(collectionName)
//
//
//        collectionRef.getDocuments()  { (querySnapshot, err) in
//            if let err = err {
//                print("Error retrieving posts: \(err.localizedDescription)")
//            } else if let querySnapshot = querySnapshot {
//                for document in querySnapshot.documents {
//                    let post = ForumPost(
//                        id: document.documentID, authorID: document.data()["authorID"] as? String,
//                        category: document.data()["category"] as? String,
//                        date: document.data()["date"] as? Date,
//                        content: document.data()["content"] as? String,
//                        likeCount: document.data()["likeCount"] as? Int,
//                        comments: document.data()["comments"] as? [ForumPostComment])
//                    posts.append(post)
//                    print("added post to posts array: \(document.documentID)")
//                }
//            }
//        }
//
//
//        return posts
//    }
    
}



