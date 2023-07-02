//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 6/28/23.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
