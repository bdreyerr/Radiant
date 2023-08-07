//
//  ForumCreateCommentView.swift
//  Radiant
//
//  Created by Ben Dreyer on 6/11/23.
//

import SwiftUI

struct ForumCreateCommentView: View {
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    @State var text: String = ""
    let title: String?
    let post: Post?
    
    var body: some View {
        ZStack {
            // This is the background image.
            Image("Dark_Hills_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
         
            VStack {
                
                if let post = post {
                    VStack(alignment: .leading) {
                        HStack {
                            // Author profile picture
                            Image(post.userPhoto)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                
                                // Author Name
                                Text(post.username)
                                    .foregroundColor(.white)
                                
                                // Date posted
                                Text("\(post.datePosted)")
                                    .foregroundColor(.white)
                            }
                            
                        }
                        .padding(.leading, 20)
                        // Post content
                        Text(post.postContent)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                            .foregroundColor(.white)
                        
                        // TODO: Make this same width as the HStack
                        Divider()
                            .background(Color.white)
                        
                    }
                    .padding(.bottom, 20)
                    .padding(.top, 80)
                }
                

                HStack {
                    // Close popup Button
                    
                    Button(action: {
                        forumManager.isCreateCommentPopupShowing = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    
                    
                        Text("New Comment")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .center)
//                            .padding(.trailing, 10)
                    
                    
                    Button(action: {
                        print("User wanted to submit a comment with the following text: \(text)")
                        if let user = profileStateManager.userProfile {
//                            if let post = post {
//                                forumManager.publishComment(authorID: user.id!, category: title!, postID: post.postID, content: text)
//                                forumManager.isCreateCommentPopupShowing = false
//                            }
                            if forumManager.focusedPostID != "" {
                                if forumManager.focusedPostCategoryName != "" {
                                    forumManager.publishComment(authorID: user.id!, authorUsername: user.displayName!, authorProfilePhoto: user.userPhotoNonPremium ?? "Selection Mix II", category: forumManager.focusedPostCategoryName, postID: forumManager.focusedPostID, content: text)
                                    if forumManager.isErrorCreatingComment == false {
                                        forumManager.isCreateCommentPopupShowing = false
                                    }
                                    
                                }
                            }
                        }
                    }) {
                        Text("Submit")
                            .foregroundColor(.blue)
                            .font(.system(size: 18))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 10)
                    .padding(.leading, 30)
                    
                    
                }
                
                if forumManager.isErrorCreatingComment {
                    Text(forumManager.errorText)
                        .foregroundColor(.red)
                }
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue, lineWidth: 4)
                    .frame(maxWidth: 350, maxHeight: 100)
                    .overlay(
                        TextField("Enter comment here", text: $text)
                            .padding(.leading, 20)
                    )
                    
        
//                RoundedRectangle(cornerRadius: 200)
//                    .frame(maxWidth: 350, maxHeight: 200)
//                    .background(Color.gray)
//                    .foregroundColor(.gray)
//                    .overlay(TextField("Enter text here", text: $text).foregroundColor(.white).cornerRadius(200)
//                        .padding(.all, 8))
                
            }
            .offset(y: -200)
            
        }
        .onDisappear {
            forumManager.isErrorCreatingComment = false
            forumManager.errorText = ""
        }
    }
}

struct ForumCreateCommentView_Previews: PreviewProvider {
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    static var previews: some View {
        ForumCreateCommentView(title: "General", post: Post(postID: "123", category: "General", userPhoto: "default_prof_pic", username: "south", datePosted: Date.now, postContent: "Just the post content", likes: ["ac2323gf"], commentCount: 1, title: "General"))
            .environmentObject(ProfileStatusManager())
            .environmentObject(ForumManager())
    }
}
