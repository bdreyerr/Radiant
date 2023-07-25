//
//  CheckInManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/17/23.
//

import Foundation
import FirebaseFirestore


class CheckInManager: ObservableObject {
    @Published var happinessSliderVal: Double = 5.0
    @Published var depressionSliderVal: Double = 5.0
    @Published var anxeitySliderVal: Double = 5.0
    
    @Published var goalOne: String = ""
    @Published var goalTwo: String = ""
    @Published var goalThree: String = ""
    
    @Published var gratitude: String = ""
    
    let db = Firestore.firestore()
    
    func checkIn(userID: String) {
        
        print("user wanted to check in and send the goals, user: \(userID)")
        let documentRef = db.collection("users").document(userID)
        
        // delete old goals
        documentRef.updateData([
            "goals": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error clearing goals: \(err)")
            } else {
                print("Document successfully updated")
            }
        } 
        
        // store new data
        documentRef.updateData([
            "goals": FieldValue.arrayUnion([goalOne, goalTwo, goalThree]),
            "gratitude": gratitude,
            "happinessScores": FieldValue.arrayUnion([happinessSliderVal]),
            "depressionScores": FieldValue.arrayUnion([depressionSliderVal]),
            "anxietyScores": FieldValue.arrayUnion([anxeitySliderVal]),
            "lastCheckinDate": Date()
        ]) { err in
            if let err = err {
                print("error updating userProfile after checkin: \(err.localizedDescription)")
            } else {
                print("user goals added")
            }
        }
    }
}
