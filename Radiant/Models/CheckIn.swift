//
//  CheckIn.swift
//  Radiant
//
//  Created by Ben Dreyer on 8/11/23.
//

import Foundation


struct CheckIn: Codable {
    var date: Date?
    var goals: [String]?
    var gratitude: String?
    var happinessScore: Double?
    var depressionScore: Double?
    var anxietyScore: Double?
    var journalEntry: String?
}
