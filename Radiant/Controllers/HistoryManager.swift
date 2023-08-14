//
//  HistoryManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/12/23.
//

import Foundation
import FirebaseFirestore


class HistoryManager: ObservableObject {
    @Published var focusedDay: Day?
    
    @Published var days: [Day] = []
    @Published var userCheckIns: [String : CheckIn] = [:]
    
    let db = Firestore.firestore()
    
    init(){
        // Generate a Day object for each day from today to 3 months ago
        let today = Date()
        let threeMonthsAgo = Date() - 7776000
        var curDay = threeMonthsAgo
        while (curDay <= today) {
            
            var newDay = Day(dayOfMonth: -1, month: "", formattedDateForFirestore: "")
            
            // Get the day of the month as an int
            let components = Calendar.current.dateComponents([.day], from: curDay)
            newDay.dayOfMonth = components.day!
            
            // Get the month as a string
            newDay.month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: curDay) - 1]
            
            // Format the current date
            newDay.formattedDateForFirestore = curDay.formatted(date: .abbreviated, time: .omitted)
            
            // append a new Day object to the Days array
            self.days.append(newDay)
            
            curDay += 86400
        }
        self.focusedDay = self.days[self.days.count-1]
    }
    
    func crossCheckDaysWithCheckInsFromFirstore(userId: String) {
        
        // Read each checkIn with the user's ID attatched
        //   Add the check-In to the map of {date: checkIn}
        //     Read each of the days from the [days] array of the last 3 months
        //        if there exists a check-in for that day in the {date: checkin} map, attatch the checkIn to the Day() object, which can be accessed from the view
        
        // Get the user's checkIns from firebase and store them in the usercheckIns map
        db.collection("checkIns").whereField("userId", isEqualTo: userId)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting user's checkins: ", err.localizedDescription)
                } else {
                    for document in querySnapshot!.documents {
                        let date = document.data()["date"] as? String
                        let goals = document.data()["goals"] as? [String]
                        let gratitude = document.data()["gratitude"] as? String
                        let happinessScore = document.data()["happinessScore"] as? Double
                        let depressionScore = document.data()["depressionScore"] as? Double
                        let anxietyScore = document.data()["anxietyScore"] as? Double
                        let journalEntry = document.data()["journalEntry"] as? String
                        let checkIn = CheckIn(userId: userId, date: date, goals: goals, gratitude: gratitude, happinessScore: happinessScore, depressionScore: depressionScore, anxietyScore: anxietyScore, journalEntry: journalEntry)
                        self.userCheckIns[date!] = checkIn
                    }
                    
                    // Read each of the days in the days array and attatch the check-in if it exists
                    for var i in 0...self.days.count - 1 {
                        if let daysCheckIn = self.userCheckIns[self.days[i].formattedDateForFirestore] {
                            self.days[i].doesCheckInExist = true
                            self.days[i].checkIn = daysCheckIn
                            print("day exists for ", self.days[i].formattedDateForFirestore)
                        } else {
                            self.days[i].doesCheckInExist = false
                            print("day doesn't exist for ", self.days[i].formattedDateForFirestore)
                        }
                        i += 1
                    }
                }
            }
        
    }
}


struct Day: Identifiable, Equatable {
    static func == (lhs: Day, rhs: Day) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    
    // Variables populated during generateDays()
    var id = UUID()
    var dayOfMonth: Int
    var month: String
    var formattedDateForFirestore: String
    
    // Variables populated during crossCheckDaysFromFirestore()
    var doesCheckInExist: Bool = false
    var checkIn: CheckIn?
    
    init(dayOfMonth: Int, month: String, formattedDateForFirestore: String) {
        self.dayOfMonth = dayOfMonth
        self.month = month
        self.formattedDateForFirestore = formattedDateForFirestore
    }
}
