//
//  ChatManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 6/1/23.
//

import AuthenticationServices
import CryptoKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import OpenAI


class ChatManager: ObservableObject {
    let db = Firestore.firestore()
    
    let openAI = OpenAI(apiToken: Secrets.openAiAPIKey)
    
    @Published var responseReady: Bool = false
    @Published var messages: [Message] = []
    
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
    
    func sendMessage(userID: String, content: String) {
        
        if content.count > 300 {
            print("Message length too long")
            return
        }
        
        let message = Message(userID: userID, isMessageFromUser: true, content: content, date: Date.now)
        self.messages.append(message)
        
        let collectionName = Constants.FStore.messageCollectionName
        
        var ref: DocumentReference? = nil
        do {
            try ref = db.collection(collectionName).addDocument(from: message)
            print("successfully saved message to db")
        } catch {
            print("Error saving message to firestore")
        }

                
        // Generate OpenAI response
        let query = ChatQuery(model: .gpt3_5Turbo, messages: [.init(role: .user, content: content)], maxTokens: 60)
        openAI.chats(query: query) { result in
          // Handle result here
            switch result {
            case .success(let result):
                if let response = result.choices[0].message.content {
                    print("OPENAI RESPONSE: \(response)")
                    let responseMessage = Message(userID: userID, isMessageFromUser: false, content: response, date: Date.now)
                    do {
                        try ref = self.db.collection(collectionName).addDocument(from: responseMessage)
                        print("successfully saved response message to db")
                        self.retrieveMessages(userID: userID)
                    } catch {
                        print("Error saving response message to firestore")
                    }
                } else {
                    print("Response from openAI empty")
                }
            case .failure(let error):
                print("Error getting result: \(error.localizedDescription)")
            }
        }
    }
    
    func clearMessages(userID: String) {
        print("user wanted to reset chat")
        // lookup and delete all messages where the userID = userID
        let collectionRef = self.db.collection(Constants.FStore.messageCollectionName)
        let query = collectionRef.whereField("userID", isEqualTo: userID)
        
        query.getDocuments() { (snapshot, error) in
            if let err = error {
                print("error getting messages to delete: \(err.localizedDescription)")
                return
            }
            
            for document in snapshot!.documents {
                document.reference.delete() { error in
                    if let e = error {
                        print("error deleting document: \(e.localizedDescription)")
                    } else {
                        print("Document deleted!")
                    }
                }
            }
            self.messages = []
        }
    }
    
}
