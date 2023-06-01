//
//  ChatManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 6/1/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


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
    func retrieveMessages() {
        
    }
}
