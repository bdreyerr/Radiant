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
import FirebaseStorage

class HomeManager: ObservableObject {
    
    @Published var isCheckInPopupShowing: Bool = false
    
    @Published var hasUserCheckedInToday: Bool = false
    @Published var userFirstName: String = "User"
    @Published var userProfilePhoto: String = "default_prof_pic"
    
    @Published var goals: [String] = ["Please check-in to set your goals", "", ""]
    @Published var gratitude: String = "I'm grateful for you!"
    
    
    var totalDepressionScores: [Double] = []
    var totalAnxietyScores: [Double] = []
    var totalHappinessScores: [Double] = []
    
    @Published var visibleDepressionScores: [Double] = []
    @Published var visibleAnxietyScores: [Double] = []
    @Published var visibleHappinessScores: [Double] = []
    
    @Published var quoteOfTheDay: String = ""
    
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    

    
    // initiate variables in the HomeManager on appear
    func userInit(userID: String) {
        
        // Get users profile photo
//        let Ref = storage.reference(forURL: "profile_pictures/RadiantBotPic.png")
//        // Download photo in memory
//        Ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                self.userProfilePhoto = UIImage(data: data!)
//            }
//        }
        
        let userDocRef = db.collection("users").document(userID)
        
        // Get last check in date
        
        // retrieve user mood scores
        
        // get goals and gratitude
//        self.goals = []
        
        // Get the day of the month for the quote of the day
        let day = Calendar.current.component(.day, from: Date())
        print("day of the month: \(day)")
        let quoteRef = db.collection("quotes").document("\(day)")
        quoteRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.quoteOfTheDay = document.data()!["quote"] as! String
            } else {
                print("Quote of the day does exist")
            }
        }
        
        
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // Get first name
                if let firstName = document.data()!["name"] as? String {
                    self.userFirstName = firstName
                }
                
                // Get photo
                if let userProfilePhoto = document.data()!["userPhotoNonPremium"] as? String {
                    self.userProfilePhoto = userProfilePhoto
                    print(self.userProfilePhoto)
                } else {
                    print("no profile photo")
                }
                
                // get last check in date
                if let lastCheckinDate = document.data()!["lastCheckinDate"] as? Timestamp {
                    
                    print(lastCheckinDate)
                    // Figure out how to check how long ago this is
                    
                } else {
                    print("last check in date doesn't exist")
                }

                // get happiness scores
                if let happinessScores = document.data()!["happinessScores"] as? [Double] {
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
                    if goals.count >= 1 {
                        self.goals[0] = goals[0]
                    }
                    if goals.count >= 2 {
                        self.goals[1] = goals[1]
                    }
                    if goals.count >= 3 {
                        self.goals[2] = goals[2]
                    }
//                    self.goals = goals
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
