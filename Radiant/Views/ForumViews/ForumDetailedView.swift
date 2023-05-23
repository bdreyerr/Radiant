//
//  ForumDetailedView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/22/23.
//

import SwiftUI

struct ForumDetailedView: View {
    
    let title: String?
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
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
                        print("User clicked the create post button")
                        // Set forumManager vars
                        if let user = profileStateManager.userProfile {
                            forumManager.authorID = user.id!
                        }
                        forumManager.category = title ?? "General"
                        forumManager.content = postContents[Int.random(in: 0...4)]
                        
                        // Save the post to firebase
                        forumManager.publishPost()
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
                        Post(userPhoto: "", username: "kingletdown", datePosted: "", postContent: postContents[0])
                        Post(userPhoto: "", username: "foreskin", datePosted: "", postContent: postContents[1])
                        Post(userPhoto: "", username: "twentynine", datePosted: "", postContent: postContents[2])
                        Post(userPhoto: "", username: "poopybutt", datePosted: "", postContent: postContents[3])
                        Post(userPhoto: "", username: "okayokay", datePosted: "", postContent: postContents[4])
                        Post(userPhoto: "", username: "gordi", datePosted: "", postContent: postContents[0])
                        Post(userPhoto: "", username: "shmorti", datePosted: "", postContent: postContents[1])
                        Post(userPhoto: "", username: "florti", datePosted: "", postContent: postContents[2])
                    }
                    .padding(.trailing, 30)
                    .padding(.leading, 20)
                    .padding(.bottom, 1)
                }
                
            }.padding(.top, 80)
        }
        .foregroundColor(Color(uiColor: .white))
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
    let userPhoto: String
    let username: String
    let datePosted: String
    let postContent: String
    
    @State private var likeCount = 5
    @State private var commentCount = 4
    
    var body: some View {
        // Post
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
                    Text("5/18/12 2:12pm")
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
                    print("User commented on the post")
                }) {
                    Image(systemName: "text.bubble")
                        .resizable()
                        .frame(width: 18, height: 18)
                    
                    Text("\(commentCount)")
                }
                // Report
                Button(action: {
                    print("User commented on the post")
                }) {
                    Image(systemName: "exclamationmark.circle")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
        }
        .padding(.bottom, 10)
        
        Divider()
            .background(Color.white)
    }
}
