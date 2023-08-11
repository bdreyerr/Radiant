//
//  ForumCreatePostView.swift
//  Radiant
//
//  Created by Ben Dreyer on 6/8/23.
//

import SwiftUI

struct ForumCreatePostView: View {
    
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @EnvironmentObject var forumManager: ForumManager
    
    @State var text: String = ""
    let title: String?
    
    var body: some View {
        ZStack {
            // This is the background image.
            Image("Dark_Hills_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
         
            VStack {
                
                HStack {
                    // Close popup Button
                    
                    Button(action: {
                        forumManager.isCreatePostPopupShowing = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    
                    
                    VStack {
                        Text("New Post")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 20))
                            
                        
                        Text(title ?? "General")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    
                    
                    Button(action: {
                        print("User wanted to submit a post with the following text: \(text)")
                        if let user = profileStateManager.userProfile {
                            forumManager.publishPost(authorID: user.id!, authorUsername: user.displayName!, authorProfilePhoto: user.userPhotoNonPremium ?? "default_prof_pic", category: title!, content: text)
                        }
                    }) {
                        Text("Submit")
                            .foregroundColor(.blue)
                            .font(.system(size: 20))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 10)
                    
                    
                }
                .padding(.top, 300)
                
                if forumManager.isErrorCreatingPost {
                    Text(forumManager.errorText)
                        .foregroundColor(.red)
                }
                
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.blue, lineWidth: 4)
//                    .frame(maxWidth: 350, maxHeight: 100)
//                    .overlay(
//                        TextField("Enter post here", text: $text)
//                            .padding(.leading, 20)
//                    )
                TextField("Enter text", text: $text, axis: .vertical)
                    .font(.system(size: 20, design: .serif))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .lineLimit(5...10)
//                                    .frame(width: 300)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(minWidth: 200, minHeight: 100, maxHeight: 300)
                    )
                
                Spacer()
                
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .scrollDismissesKeyboard(.immediately)
            
        }
        .onDisappear {
            forumManager.isErrorCreatingPost = false
            forumManager.errorText = ""
        }
    }
}

struct ForumCreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        ForumCreatePostView(title: "General")
            .environmentObject(ForumManager())
    }
}
