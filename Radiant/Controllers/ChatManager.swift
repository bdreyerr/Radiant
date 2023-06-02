//
//  ChatManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 6/1/23.
//

import Foundation
import AuthenticationServices
import CryptoKit
import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class ChatManager: ObservableObject {
    let db = Firestore.firestore()
    
    let responses = ["The cat sat on the mat.",
                     "The dog chased the ball.",
                     "The bird flew away.",
                     "The sun is shining brightly.",
                     "The rain is pouring down.",
                     "The wind is blowing fiercely.",
                     "The flowers are blooming beautifully.",
                     "The trees are green and lush.",
                     "The sky is blue and cloudless.",
                     "The stars are twinkling in the night sky."]
    
    func sendMessage(userID: String, content: String) {
        print("User sent a message")
        let message = Message(userID: userID, isMessageFromUser: true, content: content, date: Date.now)
        
        let collectionName = Constants.FStore.messageCollectionName
        
        var ref: DocumentReference? = nil
        do {
            try ref = db.collection(collectionName).addDocument(from: message)
            print("successfully saved message to db")
        } catch {
            print("Error saving message to firestore")
        }
        
        let response = generateResponse()
        let responseMessage = Message(userID: userID, isMessageFromUser: false, content: response, date: Date.now)
        
        do {
            try ref = db.collection(collectionName).addDocument(from: responseMessage)
            print("successfully saved response message to db")
        } catch {
            print("Error saving response message to firestore")
        }
    }
    
    func generateResponse() -> String {
        let response = responses[Int.random(in: 0...9)]
        return response
    }
    
    // TODO: Fill in and move into the view to load the messages into a list
    func retrieveMessages(userID: String) {
        
        var messages: [Message] = []
        
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
                    messages.append(message)
                    print("Message was retrieved, messageID: \(document.documentID), message content: \(document.data()["content"] as? String ?? "No Content")")
                }
            }
        }
    }
    
    func clearMessages(userID: String) {
        
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
        }
    }
    
}
