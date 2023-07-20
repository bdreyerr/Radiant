//
//  HomeManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 7/8/23.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class HomeManager: ObservableObject {
    
    @Published var isCheckInPopupShowing: Bool = false
    
    @Published var hasUserCheckedInToday: Bool = false
    
    @Published var goals: [String] = []
    @Published var gratitude: String = "I'm grateful for you!"
    
    
    var totalDepressionScores: [Double] = []
    var totalAnxietyScores: [Double] = []
    var totalHappinessScores: [Double] = []
    
    @Published var visibleDepressionScores: [Double] = []
    @Published var visibleAnxietyScores: [Double] = []
    @Published var visibleHappinessScores: [Double] = []
    
    
    
    let db = Firestore.firestore()
    
    // initiate variables in the HomeManager on appear
    func userInit(userID: String) {
        
        let userDocRef = db.collection("users").document(userID)
        
        // Get last check in date
        
        // retrieve user mood scores
        
        // get goals and gratitude
        self.goals = []
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {

                // get happiness scores
                if let happinessScores = document.data()!["happinessScores"] as? [Double] {
                    print(happinessScores)
                    self.totalHappinessScores = happinessScores
                    
                    // if < 7 values in the array, or if exactly 7, do nothing
                    if self.totalHappinessScores.count <= 7 {
                        self.visibleHappinessScores = self.totalHappinessScores
                    }
                    
                    
                    // if more than 7 values, get the 7 latest values
                    if self.totalHappinessScores.count > 7 {
                        self.visibleHappinessScores = self.totalHappinessScores.reversed().suffix(7)
                    }
                }
                
                // get depression scores
                if let depressionScores = document.data()!["depressionScores"] as? [Double] {
                    self.totalDepressionScores = depressionScores
                    
                    // if < 7 values in the array, or if exactly 7, do nothing
                    if self.totalDepressionScores.count < 7 || self.totalDepressionScores.count == 7{
                        self.visibleDepressionScores = self.totalDepressionScores
                    }
                    
                    
                    // if more than 7 values, get the 7 latest values
                    if self.totalDepressionScores.count > 7 {
                        self.visibleDepressionScores = self.totalDepressionScores.reversed().suffix(7)
                    }
                }
                
                // get anxiety scores
                if let anxietyScores = document.data()!["anxietyScores"] as? [Double] {
                    self.totalAnxietyScores = anxietyScores
                    
                    // if < 7 values in the array, or if exactly 7, do nothing
                    if self.totalAnxietyScores.count < 7 || self.totalAnxietyScores.count == 7{
                        self.visibleAnxietyScores = self.totalAnxietyScores
                    }
                    
                    
                    // if more than 7 values, get the 7 latest values
                    if self.totalAnxietyScores.count > 7 {
                        self.visibleAnxietyScores = self.totalAnxietyScores.reversed().suffix(7)
                    }
                }
                
                
                // get goals
                if let goals = document.data()!["goals"] as? [String] {
                    self.goals = goals
                }
                
                // get gratitude
                if let gratitude = document.data()!["gratitude"] as? String {
                    self.gratitude = gratitude
                }
                
                
            } else {
                print("User doc does not exist")
            }
        }
    }
}
