//
//  ForumSinglePostView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/27/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
//import FirebaseFirestoreSwift

struct ForumSinglePostView: View {
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    // Todo: Rework this view taking in a view as an argument, and make it the postID.
    //       Then use firebase to look up the info from that post
    @State var post: Post?
    let postID: String?
    let categoryName: String?
    
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
                if let post = post {
                    
                    VStack(alignment: .leading) {
                        
                        
                        HStack(alignment: .top) {
                            // Author profile picture
                            // TODO: Add storage for profile pictures and a lookup function based on userID
                            Image(post.userPhoto)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                
                                // Author Name
                                Text(post.username)
                                
                                // Date posted
                                Text("\(post.datePosted)")
                            }
                            
                        }
                        
                        // Post content
                        Text(post.postContent)
                        
                        VStack(alignment: .center) {
                            // TODO: Make this same width as the HStack
                            Divider()
                                .background(Color.white)
                            
                            
                            HStack(alignment: .center) {
                                
                                Button(action: {
                                    print("user liked the post")
                                }) {
                                    Image(systemName: "heart")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 10)
    //                                    .padding(.leading, 340)
                                }.padding(.trailing, 15)
                                
                                Button(action: {
                                    forumManager.isCreateCommentPopupShowing = true
                                }) {
                                    Image(systemName: "arrowshape.turn.up.left")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 10)
    //                                    .padding(.leading, 340)
                                }
                                .sheet(isPresented: $forumManager.isCreateCommentPopupShowing, onDismiss: {
                                    self.retrieveComments()
                                }) {
                                    ForumCreateCommentView(title: "ToDO: Add title", post: self.post)
                                }.padding(.trailing, 15)
                                
                                
                                Button(action: {
                                    print("User wanted to report the post")
                                    print("The post that the user wanted to report: \(self.postID ?? "1")")
                                    forumManager.isReportPostAlertShowing = true
                                }) {
                                    Image(systemName: "exclamationmark.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 10)
    //                                    .padding(.leading, 340)
                                }
                                .alert("Reason for report", isPresented: $forumManager.isReportPostAlertShowing) {
                                    Button("Offensive", action: {
                                        forumManager.reportForumPost(reasonForReport: 0)
                                    })
                                    Button("Harmful or Dangerous", action: {
                                        forumManager.reportForumPost(reasonForReport: 1)
                                    })
                                    Button("Off Topic or Irrelevant", action: {
                                        forumManager.reportForumPost(reasonForReport: 2)
                                    })
                                    Button("Spam or Advertisment", action: {
                                        forumManager.reportForumPost(reasonForReport: 3)
                                    })
                                    Button("Cancel", action: {
                                        forumManager.isReportPostAlertShowing = false
                                    })
                                }
                                
                            }
                            
                            
                            
                            
                            Divider()
                                .background(Color.white)
                        }
                        
                        
                        
                        
                        // List of comments
                        VStack {
                            ScrollView{
                                ForEach(comments) { comment in
                                    Comment(authorID: comment.authorID!, username: "username", datePosted: comment.date ?? Date.now, commentContent: comment.content!, likeCount: comment.likeCount!)
                                }
                            }
                           
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
//                    .offset(y: -150)
                    .padding(.top, 150)
                }
            }
        }
        .foregroundColor(Color(uiColor: .white))
        .onAppear {
            retrievePost() // This also retrieves comments, it's nested
        }
    }
    
    func retrievePost() {
        let docRef = db.collection(forumManager.getFstoreForumCategoryCollectionName(category: forumManager.focusedPostCategoryName)).document(forumManager.focusedPostID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
                self.post?.postID = forumManager.focusedPostID
                self.post?.category = forumManager.focusedPostCategoryName
                self.post?.userPhoto = "default_prof_pic"
                self.post?.username = document.data()!["authorID"] as! String
//                self.post?.datePosted = document.data()!["date"] as! Date
                self.post?.postContent = document.data()!["content"] as! String
                self.post?.likeCount = document.data()!["likeCount"] as! Int
                self.post?.commentCount = 1
                self.retrieveComments()
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func retrieveComments() {
        self.comments = []
        let collectionName = forumManager.getFstoreForumCommentsCategoryCollectionName(category: self.post?.category ?? "General")
        
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
        ForumSinglePostView(post: Post(postID: "23", category: "General", userPhoto: "default_prof_pic", username: "south", datePosted: Date.now, postContent: "This is the post content", likeCount: 1, commentCount: 1, title: "General"), postID: "23", categoryName: "General")
            .environmentObject(ProfileStatusManager())
            .environmentObject(ForumManager())
    }
}


struct Comment: View {
    
    let authorID: String
    let username: String
    let datePosted: Date
    let commentContent: String
    let likeCount: Int
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Author profile picture
                Image("Selection Mix II")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    // Author Name
                    Text(self.username)
                        .font(.system(size: 14))
                    
                    // Date posted
                    Text("\(self.datePosted)")
                        .font(.system(size: 14))
                }
            }
            Text(self.commentContent)
                .font(.system(size: 14))
            
            HStack {
                // Like comment
                Button(action: {
                    print("User liked the comment")
                }) {
                    Image(systemName: "heart")
                        .resizable()
                        .frame(width: 14, height: 14)
                    
                    Text("\(likeCount)")
                        .font(.system(size: 12))
                }
                
                // Report
                Button(action: {
                    print("User wanted to report the comment")
                }) {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 14, height: 14)
                }
            }
            
        }
        .padding(.leading, 10)
    }
}
