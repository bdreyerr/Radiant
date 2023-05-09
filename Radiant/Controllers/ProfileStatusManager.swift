//
//  ProfileStatusManager.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/9/23.
//

import Foundation


class ProfileStatusManager: ObservableObject {
    
    // Bool var controlling the settings popup
    @Published var isProfileSettingsPopupShowing: Bool = false
    
    // This variable will store the updated information
    @Published var editableUserProfile: UserProfile?
    
    
    
}
