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
                Text(title ?? "Category Title")
                    .font(.system(size: 24))
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Post(userPhoto: "", username: "kingletdown", datePosted: "", postContent: postContents[0], likecount: 0, commentCount: 0)
                        Post(userPhoto: "", username: "foreskin", datePosted: "", postContent: postContents[1], likecount: 0, commentCount: 0)
                        Post(userPhoto: "", username: "twentynine", datePosted: "", postContent: postContents[2], likecount: 0, commentCount: 0)
                        Post(userPhoto: "", username: "poopybutt", datePosted: "", postContent: postContents[3], likecount: 0, commentCount: 0)
                        Post(userPhoto: "", username: "okayokay", datePosted: "", postContent: postContents[4], likecount: 0, commentCount: 0)
                        Post(userPhoto: "", username: "gordi", datePosted: "", postContent: postContents[0], likecount: 0, commentCount: 0)
                        Post(userPhoto: "", username: "shmorti", datePosted: "", postContent: postContents[1], likecount: 0, commentCount: 0)
                        Post(userPhoto: "", username: "florti", datePosted: "", postContent: postContents[2], likecount: 0, commentCount: 0)
                    }
                    .padding(.trailing, 30)
                    .padding(.leading, 20)
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
    }
}


struct Post: View {
    let userPhoto: String
    let username: String
    let datePosted: String
    let postContent: String
    let likecount: Int
    let commentCount: Int
    
    var body: some View {
        // Post
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                // User profile picture
                Image("default_prof_pic")
                    .resizable()
                    .frame(width: 50, height: 50)
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
                        .fixedSize(horizontal: true, vertical: true)
                }
                // Comment
                Button(action: {
                    print("User commented on the post")
                }) {
                    Image(systemName: "text.bubble")
                        .fixedSize(horizontal: true, vertical: true)
                }
                // Report
                Button(action: {
                    print("User commented on the post")
                }) {
                    Image(systemName: "exclamationmark.circle")
                        .fixedSize(horizontal: true, vertical: true)
                }
            }
        }
        .padding(.bottom, 10)
    }
}
