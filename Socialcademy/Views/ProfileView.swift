//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 7/1/23.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Button("Sign Out", action: {
            try! Auth.auth().signOut()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
