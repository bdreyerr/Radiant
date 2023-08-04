//
//  ChatMainView.swift
//  Radiant
//
//  Created by Ben Dreyer on 6/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ChatMainView: View {
    
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)

    @State var text: String
    
    @EnvironmentObject var authStateManager: AuthStatusManager
    @EnvironmentObject var profileStateManager: ProfileStatusManager
    @StateObject var chatManager = ChatManager()
    
    let db = Firestore.firestore()
    
    @State var messages: [Message] = []
    var welcomeMessage = "Hi there! I'm Radiant Bot, a chatbot designed to help you with your mental health. You can talk to me to help with your mental health questions, find professional help, and improve your mood. It's important to remember that I'm not a therapist, but you can ask me all types of questions and I'll help you as best I can!"
    
    var body: some View {
        ZStack {
            Image("Chat_BG")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    Text("Radiant Chat")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                    
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
                
                ScrollViewReader { value in
                    // This is the scroll view.
                    ScrollView {
                        // Messages
                        VStack(alignment: .leading) {
                            MessageFromBot(text: welcomeMessage)
                            ForEach(messages, id: \.id) { message in
                                if message.id != nil {
                                    if (message.isMessageFromUser!) {
                                        if let userPhoto = profileStateManager.userProfile?.userPhotoNonPremium {
                                            MessageFromYou(text: message.content, profilePhoto: Image(userPhoto))
                                                .id(message.id)
                                        } else {
                                            MessageFromYou(text: message.content, profilePhoto: Image("default_prof_pic"))
                                                .id(message.id)
                                        }
//                                        MessageFromYou(text: message.content)
//                                            .id(message.id)
                                    } else {
                                        MessageFromBot(text: message.content)
                                            .id(message.id)
                                    }
                                } else {
                                    Text("Messages would be here!")
                                }
                            }
                        }
                    }
                    .padding(.top, 5)
                    .padding(.bottom, 5)
                    .onAppear {
                        value.scrollTo(self.messages.last?.id)
                    }
                    .onChange(of: self.messages.count) { _ in
                        value.scrollTo(self.messages.last?.id)
                    }
                    
                }
                // Message send bar
                HStack {
                    TextField("Enter text", text: $text)
                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 40).foregroundColor(.white)).frame(minWidth: 320, maxWidth: 400, maxHeight: 40)
                        .foregroundColor(.white)
                        .padding(.leading, 35)
                        .background(GeometryGetter(rect: $kGuardian.rects[0]))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                                .padding(.leading, 35)
                        )
                        
                        
                    if self.text == "" {
                        Button(action: {
                            // Do nothing if no text is entered
                        }) {
                            Image(systemName: "paperplane")
                                .resizable()
                                .frame(maxWidth: 25, maxHeight: 25, alignment: .trailing)
                                .padding(.leading, 15)
                                .foregroundColor(.gray)
                                .padding(.trailing, 40)
                        }
                    } else {
                        Button(action: {
                            if let user = profileStateManager.userProfile {
                                chatManager.sendMessage(userID: user.id!, content: self.text)
                                self.retrieveMessages(userID: user.id!)
                            }
                            self.text = ""
                        }) {
                            Image(systemName: "paperplane")
                                .resizable()
                                .frame(maxWidth: 25, maxHeight: 25, alignment: .trailing)
                                .padding(.leading, 15)
                                .foregroundColor(.blue)
                                .padding(.trailing, 40)
                        }
                    }
                }
                .padding(.bottom, 140)
            }
            .padding(.top, 80)
            .offset(y: kGuardian.slide)
            .animation(.easeInOut(duration: 1.0))
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

struct ChatMainView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMainView(text: "hello")
    }
}


struct MessageFromYou : View {
    let text: String?
    let profilePhoto: Image?
    var body: some View {
        
        HStack {
            ZStack {
                // Create the bubble shape
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                
                // Add the text content
                Text(text ?? "No text")
                    .padding()
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.leading, 60)
            
            profilePhoto!
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.trailing, 10)
            
        }
        .padding(.trailing, 8)
        
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.trailing, 50)
            
        }
        .padding(.leading, 15)
        
    }
}


struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        GeometryReader { geometry in
            Group { () -> AnyView in
                DispatchQueue.main.async {
                    self.rect = geometry.frame(in: .global)
                }

                return AnyView(Color.clear)
            }
        }
    }
}
