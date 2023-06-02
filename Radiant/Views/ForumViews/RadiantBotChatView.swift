//
//  RadiantBotChatView.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/30/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RadiantBotChatView: View {
    
    @State var text: String
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @StateObject var chatManager = ChatManager()
    
    let db = Firestore.firestore()
    
    @State var messages: [Message] = []
    
    var body: some View {
        ZStack {
            
            VStack {
                
                HStack {
                    Text("Radiant Chat")
                        .font(.system(size: 24))
                    
                }
                
                Button(action: {
                    self.messages = []
                    if let user = profileStateManager.userProfile {
                        chatManager.clearMessages(userID: user.id!)
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .frame(maxWidth: 20, maxHeight: 20, alignment: .trailing)
                        .padding(.leading, 250)
                        .foregroundColor(.white)
                }
                
                
                
                
                
                
                // This is the scroll view.
                ScrollView {
                    
                    // Messages
                    VStack(alignment: .leading) {
                        
                        ForEach(messages) { message in
                            if message.id != nil {
                                if (message.isMessageFromUser!) {
                                    MessageFromYou(text: message.content)
                                } else {
                                    MessageFromBot(text: message.content)
                                }
                            } else {
                                Text("Messages would be here!")
                            }
                        }
                        
                    }
                    
                }.padding(.top, 20)
                
                // Message send bar
                HStack {
                    TextField("Enter text", text: $text)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 40).foregroundColor(.white)).frame(maxWidth: 360, maxHeight: 40)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 2).frame(width: 360, height: 40)
//                        )
                        .foregroundColor(.black)
//                        .padding(.bottom, 100)
                    
                        .padding(.leading, 70)
                    
                    Button(action: {
                        if let user = profileStateManager.userProfile {
                            chatManager.sendMessage(userID: user.id!, content: self.text)
                            self.retrieveMessages(userID: user.id!)
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
        .onAppear {
            if let user = profileStateManager.userProfile {
                retrieveMessages(userID: user.id!)
            }
        }
    }
    
    
    func retrieveMessages(userID: String) {
        self.messages = []
        
        let collectionRef = self.db.collection(Constants.FStore.messageCollectionName).whereField("userID", isEqualTo: userID).order(by: "date", descending: false)
        
        collectionRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error retrieving comments: \(err.localizedDescription)")
            } else if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    let message = Message(
                        id: document.documentID,
                        userID: document.data()["userID"] as? String,
                        isMessageFromUser: document.data()["isMessageFromUser"] as? Bool,
                        content: document.data()["content"] as? String,
                        date: document.data()["date"] as? Date)
                    self.messages.append(message)
                    print("Message was retrieved, messageID: \(document.documentID), message content: \(document.data()["content"] as? String ?? "No Content")")
                }
            }
        }
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
