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
                        forumManager.isCreatePostPopupShowing = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .sheet(isPresented: $forumManager.isCreatePostPopupShowing) {
                        ForumCreatePostView(title: title)
                            .onDisappear(perform: {
                                retrievePosts()
                            })
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
                            Post(postID: post.id!, category: self.title ?? "General" , userPhoto: "", username: post.authorID!, datePosted: post.date ?? Date.now, postContent: post.content!, likeCount: post.likeCount!, commentCount: 1, title: self.title)
                        }
                        
//                        List(posts) { post in
//                            Post(postID: post.id!, category: self.title ?? "General" , userPhoto: "", username: post.authorID!, datePosted: post.date ?? Date.now, postContent: post.content!, likeCount: post.likeCount!, commentCount: 1, title: self.title)
//                        }.onAppear() {
//                            self.retrievePosts()
//                        }
                        
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
    
    let title: String?
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager

    
    var body: some View {
        // Post
        
        Button(action: {
            print("The post ID that was clicked on: \(self.postID)")
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
                        forumManager.isCreateCommentPopupShowing = true
                    }) {
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(commentCount)")
                    }
                    .sheet(isPresented: $forumManager.isCreateCommentPopupShowing) {
                        ForumCreateCommentView(title: self.category, post: self)
                    }
                    // Report
                    Button(action: {
                        print("User wanted to report the post")
                        forumManager.isReportPostAlertShowing = true
                    }) {
                        Image(systemName: "exclamationmark.circle")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }.alert("Reason for report", isPresented: $forumManager.isReportPostAlertShowing) {
                        Button("Offensive", action: {
                            forumManager.reportForumPost(postID: self.postID, reasonForReport: 0, categoryName: self.title!)
                            
                        })
                        Button("Harmful or Dangerous", action: {
                            forumManager.reportForumPost(postID: self.postID, reasonForReport: 1, categoryName: self.title!)
                        })
                        Button("Off Topic or Irrelevant", action: {
                            forumManager.reportForumPost(postID: self.postID, reasonForReport: 2, categoryName: self.title!)
                        })
                        Button("Spam or Advertisment", action: {
                            forumManager.reportForumPost(postID: self.postID, reasonForReport: 3, categoryName: self.title!)
                        })
                        Button("Cancel", action: {
                            forumManager.isReportPostAlertShowing = false
                        })
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
