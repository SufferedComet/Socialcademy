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

extension Post {
    static let testPost = Post(title: "Lorem ipsum", content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", authorName: "Jamie Harris")
}
