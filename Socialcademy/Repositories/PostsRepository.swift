//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 6/29/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Protocol
protocol PostsRepositoryProtocol {
    func fetchAllPosts() async throws -> [Post]
    func create(_ post: Post) async throws
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
    func fetchFavoritePosts() async throws -> [Post]
    func fetchPosts(by author: User) async throws -> [Post]
    var user: User { get }
}

// MARK: - PostRepository
struct PostsRepository: PostsRepositoryProtocol {
     let postsReference = Firestore.firestore().collection("posts_v2")
     let user: User
    
    // MARK: - PR Functions
    // Uploads data to firestore database
     func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    // Deletes data from firestore database
    func delete(_ post: Post) async throws {
        precondition(canDelete(post))
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    // Toggles isFavorite boolean to true on the firestore database
    func favorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": true], merge: true)
    }
    
    // Downloads all data from firestore database
     func fetchAllPosts() async throws -> [Post] {
         return try await fetchPosts(from: postsReference)
    }
    
    // Downloads isFavorite data
    func fetchFavoritePosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("isFavorite", isEqualTo: true))
    }
    
    // Downloads data by author from firestore database
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("author.id", isEqualTo: author.id))
    }
    
    // Toggles isFavorite boolean to false on the firestore database
    func unfavorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": false], merge: true)
    }
    
    // Helper method to download data from firestore database
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let snapshot = try await query
            .order(by: "timestamp", descending: true)
            .getDocuments()
        return snapshot.documents.compactMap { document in
            try! document.data(as: Post.self)
        }
    }
}

// MARK: - Extensions
extension PostsRepositoryProtocol {
    
    // MARK: - Extension Functions
    func canDelete(_ post: Post) -> Bool {
        post.author.id == user.id
    }
    
    func fetchPosts(matching filter: PostsViewModel.Filter) async throws -> [Post] {
        switch filter {
        case .all:
            return try await fetchAllPosts()
        case let .author(author):
            return try await fetchPosts(by: author)
        case .favorites:
            return try await fetchFavoritePosts()
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

// MARK: - PostRepositoryStub
#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    let state: Loadable<[Post]>
    var user = User.testUser
    
    func create(_ post: Post) async throws {}
    
    func delete(_ post: Post) async throws {}
    
    func favorite(_ post: Post) async throws {}
    
    func fetchAllPosts() async throws -> [Post] {
        return []
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await state.simulate()
    }
    
    func unfavorite(_ post: Post) async throws {}
}
#endif
