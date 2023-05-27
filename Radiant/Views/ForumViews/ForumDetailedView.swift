//
//  ForumDetailedView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ForumDetailedView: View {
    
    let title: String?
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    @State var posts: [ForumPost] = []
    
    let db = Firestore.firestore()
    
    var postContents = ["The dog was chasing a cat across the street.", "The man was eating a sandwich and drinking a glass of water.", "The boy was playing baseball with his friends in the park.", "The girl was playing soccer with her team on the field.,", "The sun was shining brightly in the sky, and the birds were singing."]
    
    var body: some View {
        
        ZStack {
            // This is the background image.
            Image("Forum_BG3")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Post List
            
            VStack {
                // Icons
                HStack {
                    // Create Post
                    Button(action: {
                        // Save the post to firebase if the current signed in user exists
                        if let user = profileStateManager.userProfile {
                            forumManager.publishPost(authorID: user.id!, category: title ?? "General", content: postContents[Int.random(in: 0...4)])
                            retrievePosts()
                        }
                    }) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.leading, 300)
                .padding(.top, 1)
                
                Text(title ?? "Category Title")
                    .font(.system(size: 24))
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        // look up the username with their id
                        
                        ForEach(posts) { post in
                            Post(postID: post.id!, category: self.title ?? "General" , userPhoto: "", username: post.authorID!, datePosted: post.date ?? Date.now, postContent: post.content!, likeCount: post.likeCount!, commentCount: 1)
                        }
                        
                    }
                    .padding(.trailing, 30)
                    .padding(.leading, 20)
                    .padding(.bottom, 1)
                }
                
            }.padding(.top, 80)
        }
        .foregroundColor(Color(uiColor: .white))
        .onAppear {
            retrievePosts()
        }
    }
    
    
    func retrievePosts(/*postCategory: String*/) {
        self.posts = []
        let collectionName = forumManager.getFstoreForumCategoryCollectionName(category: self.title ?? "General")
        
        let collectionRef = self.db.collection(collectionName)
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving posts: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let post = ForumPost(
                        id: document.documentID,
                        authorID: document.data()["authorID"] as? String,
                        category: document.data()["category"] as? String,
                        date: document.data()["date"] as? Date,
                        content: document.data()["content"] as? String,
                        likeCount: document.data()["likeCount"] as? Int)
                    posts.append(post)
                }
            }
        }
    }
}

struct ForumDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        
        ForumDetailedView(title: "Title")
            .environmentObject(AuthStatusManager())
            .environmentObject(ProfileStatusManager())
            .environmentObject(ForumManager())
    }
}


struct Post: View {
    let postID: String
    let category: String
    let userPhoto: String
    let username: String
    let datePosted: Date
    let postContent: String
    @State var likeCount: Int
    @State var commentCount: Int
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    var postContents = ["The dog was chasing a cat across the street.", "The man was eating a sandwich and drinking a glass of water.", "The boy was playing baseball with his friends in the park.", "The girl was playing soccer with her team on the field.,", "The sun was shining brightly in the sky, and the birds were singing."]
    
    
    
    
    var body: some View {
        // Post
        
        Button(action: {
            forumManager.isPostDetailedPopupShowing = true
        }) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    // User profile picture
                    Image("default_prof_pic")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.trailing, 10)
                    VStack(alignment: .leading) {
                        // username
                        Text(username)
                            .font(.system(size: 14))
                            .bold()
                        // date posted
                        Text(datePosted.description)
                            .font(.system(size: 14))
                    }
                    
                }
                // post content
                Text(postContent)
                    .padding(.bottom, 5)
                    .font(.system(size: 12))
                // interact buttons
                HStack {
                    // Like post
                    Button(action: {
                        print("User liked the post")
                    }) {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(likeCount)")
                    }
                    // Comment
                    Button(action: {
                        if let user = profileStateManager.userProfile {
                            forumManager.publishComment(authorID: user.id!, category: self.category, postID: self.postID, content: "Default content of a comment")
                        }
                    }) {
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(commentCount)")
                    }
                    // Report
                    Button(action: {
                        print("User commented on the post")
                        // Save the post to firebase if the current signed in user exists
                        if let user = profileStateManager.userProfile {
                            //                        forumManager.publishComment(authorID: user.id!, content: postContents[Int.random(in: 0...4)])
                            forumManager.publishComment(authorID: user.id!, category: category, postID: postID, content: "Test2")
                            //                        print("firebase should have been send, user exists")
                        }
                    }) {
                        Image(systemName: "exclamationmark.circle")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                }
            }
            .padding(.bottom, 10)
        }
        .sheet(isPresented: $forumManager.isPostDetailedPopupShowing) {
            ForumSinglePostView(post: self)
        }
        
        Divider()
            .background(Color.white)
    }
}
