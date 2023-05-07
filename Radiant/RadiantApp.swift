//
//  RadiantApp.swift
//  Radiant
//
//  Created by Ben Dreyer on 5/2/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        print("Database: \(db)")
        
        // print the login status of the user
        if let loginStatus = UserDefaults.standard.object(forKey: loginStatusKey) as? Bool {
            print("User login status on app launch finish: \( loginStatus )")
        } else {
            print("User login status on app launch finish: \( String(describing: UserDefaults.standard.object(forKey: loginStatusKey)) ))")
        }
        
        return true
    }
}

@main
struct RadiantApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
