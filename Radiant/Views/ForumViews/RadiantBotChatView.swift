//
//  RadiantBotChatView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/30/23.
//

import SwiftUI

struct RadiantBotChatView: View {
    
    @State var text: String
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @StateObject var chatManager = ChatManager()
    
    var body: some View {
        ZStack {
            
            VStack {
                
                Text("Radiant Chat")
                    .font(.system(size: 24))
                
                
                // This is the scroll view.
                ScrollView {
                    
                    // Messages
                    VStack(alignment: .leading) {
                        
                        // Message from you
                        MessageFromYou(text: "Hi Radiant Bot, you're so cool!")
                        
                        
                        // Message from Radiant Bot
                        MessageFromBot(text: "You know it G")
                        
                        
                        MessageFromYou(text: "Can you help me with my issues?")
                        
                        MessageFromBot(text: "Of course homie")
                    }
                    
                }.padding(.top, 20)
                
                // Message send bar
                
                HStack {
                    TextField("Enter text", text: $text)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 40).foregroundColor(.white)).frame(maxWidth: 360, maxHeight: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 2).frame(width: 360, height: 40)
                        )
                        .foregroundColor(.black)
//                        .padding(.bottom, 100)
                        .padding(.leading, 70)
                    
                    Button(action: {
                        if let user = profileStateManager.userProfile {
                            chatManager.sendMessage(userID: user.id!, content: self.text)
                        }
                        self.text = ""
                    }) {
                        Image(systemName: "paperplane")
                            .resizable()
                            .frame(maxWidth: 30, maxHeight: 30, alignment: .trailing)
                            .padding(.leading, 0)
                            .foregroundColor(.blue)
                            .padding(.trailing, 40)
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .background(Color.clear)
        .environmentObject(chatManager)
    }
}

struct RadiantBotChatView_Previews: PreviewProvider {
    static var previews: some View {
        RadiantBotChatView(text: "")
    }
}


struct MessageFromYou : View {
    let text: String?
    var body: some View {
        
        HStack {
            ZStack {
                // Create the bubble shape
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue)
                
                // Add the text content
                Text(text ?? "No text")
                    .padding()
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 300, maxHeight: 30)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.leading, 60)
            
            Image("default_prof_pic")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
        }
        .padding(.trailing, 10)
        
    }
}

struct MessageFromBot : View {
    let text: String?
    var body: some View {
        
        HStack {
            Image("RadiantBotPic")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
            ZStack {
                // Create the bubble shape
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.80))
                
                // Add the text content
                Text(text ?? "No text")
                    .padding()
                    .foregroundColor(.white)
            }
            .frame(maxWidth: 160, maxHeight: 30)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.leading, 0)
        }
        .padding(.leading, 10)
        
    }
}
