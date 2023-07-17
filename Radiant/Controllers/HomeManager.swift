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
    
    
    var weeklyDepressionScores: [Int] = []
    var weeklyAnxietyScores: [Int] = []
    var weeklyHappinessScores: [Int] = []
    
    
    // initiate variables in the HomeManager on appear
    func userInit(user: UserProfile) {
        // Get last check in date
        let oneDayAgo = Date() - TimeInterval(86400)
        if let lastCheckInDate = user.lastCheckinDate {
            hasUserCheckedInToday = (lastCheckInDate > oneDayAgo)
        }
        print("Has user checked in: \(self.hasUserCheckedInToday)")
        
        if let depressionScores = user.depressionScores {
            self.weeklyDepressionScores = depressionScores
            print(depressionScores)
        }
        if let anxietyScores = user.anxietyScores {
            self.weeklyAnxietyScores = anxietyScores
            print(anxietyScores)
        }
        if let happinessScores = user.happinessScores {
            self.weeklyHappinessScores = happinessScores
            print(happinessScores)
        }
    }
    
    func checkIn() {
        print("User wanted to check-in")
        
        // Write dpression scores
        
        // Write anxiety scores
        
        // Write happiness scores
        
        // Write goals
        
        
    }
    
}
