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
    
    // TODO(bendreyer): We're doing this read of the signed in userProfile twice, once here and once in the profileStatus manager. We can consolidate.
    let userProfile: UserProfile? = nil
    
    // initiate variables in the HomeManager on appear
    func userInit(userID: String) {
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
        
        let userDocRef = db.collection("users").document(userID)
        
        
        userDocRef.getDocument(as: UserProfile.self) { result in
            switch result {
            case .success(let user):
                print("we sucessfully got the user in homeManager")
                print("user id: ", user.id!)
                self.userFirstName = user.name!
                self.userProfilePhoto = user.userPhotoNonPremium!
                
                
                // Read today's checkIn data
                let today = Date().formatted(date: .abbreviated, time: .omitted)
                self.goals = (user.checkIns![today]?.goals)!
                self.gratitude = (user.checkIns![today]?.gratitude)!
                
                // Set has user checked in today boolean
                if today == user.lastCheckinDate {
                    self.hasUserCheckedInToday = true
                    print("user has already checked in today")
                } else {
                    self.hasUserCheckedInToday = false
                    print("user has not checked in today")
                }
            case .failure(let error):
                print("error getting the user in the home manger: ", error.localizedDescription)
            }
        }
    }
}
