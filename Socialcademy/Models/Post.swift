//
//  Post.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 6/28/23.
//

import Foundation

struct Post: Identifiable {
    var id = UUID()
    var title: String
    var content: String
    var authorName: String
    var timestamp = Date()
}
