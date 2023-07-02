//
//  User.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 7/1/23.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}
