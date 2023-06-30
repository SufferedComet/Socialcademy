//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 6/29/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostsRepository {
    static let postsReference = Firestore.firestore().collection("posts")
    
    // Uploads data to firestore database
    static func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    // Downloads data from firestore database
    static func fetchPosts() async throws -> [Post] {
        let snapshot = try await postsReference
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
    }
}

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}
