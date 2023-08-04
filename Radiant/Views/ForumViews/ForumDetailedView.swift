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
                        ForEach(posts, id: \.id) { post in
                            if post.id != nil {
                                Post(postID: post.id!, category: self.title ?? "General", userPhoto: post.authorProfilePhoto ?? "default_prof_pic", username: post.authorUsername ?? "Username missing", datePosted: post.date ?? Date.now, postContent: post.content!, likes:post.likes ?? [], commentCount: 1, title: self.title)
                                    .id(post.id)
                            } else {
                                Text("Unable to retrieve post")
                            }
                        }
                    }
                    .padding(.trailing, 30)
                    .padding(.leading, 20)
                    .padding(.bottom, 1)
                }
                .padding(.bottom, 40)
                .offset(y: -60)
                .padding(.top, 40)
                
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
                        authorUsername: document.data()["authorUsername"] as? String,
                        authorProfilePhoto: document.data()["authorProfilePhoto"] as? String,
                        category: document.data()["category"] as? String,
                        date: document.data()["date"] as? Date,
                        content: document.data()["content"] as? String,
                        likes: document.data()["likes"] as? [String])
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
    var postID: String
    var category: String
    var userPhoto: String
    var username: String
    var datePosted: Date
    var postContent: String
    var likes: [String]
    
    @State var commentCount: Int
    
    let title: String?
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager

    
    var body: some View {
        // Post
        
        NavigationLink(destination: ForumSinglePostView(post: Post(postID: "0", category: "0", userPhoto: "default_prof_pic", username: "0", datePosted: Date.now, postContent: "0", likes: [], commentCount: 1, title: "1"), likeCount: 0, postID: nil, categoryName: nil)) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        // User profile picture
                        Image(userPhoto)
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
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 18, height: 18)
                        
                        Text("\(likes.count)")
                        
                        // Comment count (opens single post view)
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 18, height: 18)

                        Text("\(commentCount)")
                        
                        // Report
                        Button(action: {
                            print("User wanted to report the post")
                            print("The post that the user wanted to report: \(self.postID)")
                            forumManager.focusedPostID = self.postID
                            forumManager.focusedPostCategoryName = self.category
                            forumManager.isReportPostAlertShowing = true
                        }) {
                            Image(systemName: "exclamationmark.circle")
                                .resizable()
                                .frame(width: 18, height: 18)
                        }.alert("Reason for report", isPresented: $forumManager.isReportPostAlertShowing) {
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
                }
                .padding(.bottom, 10)
        }
        .simultaneousGesture(TapGesture().onEnded{
            print("The post ID that was clicked on: \(self.postID)")
            forumManager.focusedPostID = self.postID
            forumManager.focusedPostCategoryName = self.category
        })

        
        Divider()
            .background(Color.white)
    }
}
