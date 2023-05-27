//
//  ForumSinglePostView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/27/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ForumSinglePostView: View {
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    let post: Post?
    @State var comments: [ForumPostComment] = []
    
    let db = Firestore.firestore()
    
    var body: some View {
        
        ZStack {
            // This is the background image.
            Image("Forum_BG3")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Close popup Button
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 30))
                    .offset(x: 170, y: -300)
                    .onTapGesture {
                        // Dismiss the register with email popup on tap
                        forumManager.isPostDetailedPopupShowing = false
                    }
                
                VStack {
                    HStack {
                        // Author profile picture
                        Image("default_prof_pic")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading) {
                            
                            // Author Name
                            Text("username")
                            
                            // Date posted
                            Text("May 26th 2023, 4:54pm")
                        }
                        
                    }
                    
                    // Post content
                    Text("This is the content of the post. It shouldn't exceed the size of the HStack above it.")
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    // TODO: Make this same width as the HStack
                    Divider()
                        .background(Color.white)
                    
                    // List of comments
                    VStack {
//                        Comment()
//                        Comment()
                        
                        ForEach(comments) { comment in
                            Comment()
                        }
                    }
                }
            }.offset(y: 160)
        }
        .foregroundColor(Color(uiColor: .white))
        .onAppear {
            retrieveComments()
            print("Detailed post popped up, post id: \(self.post?.postID ?? "No post id")")
        }
    }
    
    
    func retrieveComments() {
        self.comments = []
        let collectionName = forumManager.getFstoreForumCommentsCategoryCollectionName(category: post?.category ?? "General")
        
        let collectionRef = self.db.collection(collectionName).whereField("postID", isEqualTo: self.post?.postID ?? "1")
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving comments: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let comment = ForumPostComment(
                        id: document.documentID,
                        postID: document.data()["postID"] as? String,
                        parentCommentID: document.data()["parentCommentID"] as? String,
                        authorID: document.data()["authorID"] as? String,
                        date: document.data()["date"] as? Date,
                        content: document.data()["content"] as? String,
                        likeCount: document.data()["likeCount"] as? Int)
                    comments.append(comment)
                }
            }
        }
    }
}

struct ForumSinglePostView_Previews: PreviewProvider {
    static var previews: some View {
        ForumSinglePostView(post: Post(postID: "23", category: "General", userPhoto: "default_prof_pic", username: "south", datePosted: Date.now, postContent: "This is the post content", likeCount: 1, commentCount: 1))
            .environmentObject(ProfileStatusManager())
            .environmentObject(ForumManager())
    }
}


struct Comment: View {
    var body: some View {
        VStack {
            HStack {
                // Author profile picture
                Image("default_prof_pic")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    // Author Name
                    Text("username")
                    
                    // Date posted
                    Text("May 26th 2023, 4:54pm")
                }
            }
            Text("This is the comment content.")
        }
    }
}
