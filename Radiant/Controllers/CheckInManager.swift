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
    
    @Published var journalEntry: String = ""
    
    @Published var isErrorInCheckIn: Bool = false
    @Published var errorText: String = ""
    
    let db = Firestore.firestore()
    
    func checkIn(userID: String) {
        
        print("user wanted to check in and send the goals, user: \(userID)")
        
        if goalOne == "" && goalTwo == "" && goalThree == "" {
            self.isErrorInCheckIn = true
            self.errorText = "Please enter at least one goal"
            return
        }
        
        if gratitude == "" {
            self.isErrorInCheckIn = true
            self.errorText = "Please enter something you are grateful for"
            return
        } else {
            self.isErrorInCheckIn = false
            self.errorText = ""
        }
        
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
        
        
        let date = Date()
        let formattedDate = date.formatted(date: .abbreviated, time: .omitted)
        let checkIn = CheckIn(date: date, goals: [self.goalOne, self.goalTwo, self.goalThree], gratitude: self.gratitude, happinessScore: self.happinessSliderVal, depressionScore: self.depressionSliderVal, anxietyScore: self.anxeitySliderVal, journalEntry: self.journalEntry)
        
        documentRef.updateData([
            "checkIns": [
                formattedDate: [
                    "goals": [self.goalOne, self.goalTwo, self.goalThree],
                    "gratitude": self.gratitude,
                    "happinessScore": self.happinessSliderVal,
                    "depressionScore": self.depressionSliderVal,
                    "anxietyScore": self.anxeitySliderVal,
                    "journalEntry": self.journalEntry
                ],
            ],
            "lastCheckinDate": formattedDate
        ]) { err in
            if let err = err {
                print("error updating userProfile after checkin: \(err.localizedDescription)")
            } else {
                print("user goals added")
            }
        }
    }
}
