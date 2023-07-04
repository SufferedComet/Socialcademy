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
    var user: User { get }
    func fetchAllPosts() async throws -> [Post]
    func create(_ post: Post) async throws
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
    func fetchFavoritePosts() async throws -> [Post]
    func fetchPosts(by author: User) async throws -> [Post]
    
}

// MARK: - PostRepository
struct PostsRepository: PostsRepositoryProtocol {
     let postsReference = Firestore.firestore().collection("posts_v2")
     let favoritesReference = Firestore.firestore().collection("favorites")
     let user: User
    
    // MARK: - PR Functions
    // Uploads data to firestore database
     func create(_ post: Post) async throws {
         var post = post
         if let imageFileURL = post.imageURL {
             post.imageURL = try await StorageFile
                 .with(namespace: "posts", identifier: post.id.uuidString)
                 .putFile(from: imageFileURL)
                 .getDownloadURL()
         }
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    // Deletes data from firestore database
    func delete(_ post: Post) async throws {
        precondition(canDelete(post))
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
        let image = post.imageURL.map(StorageFile.atURL(_:))
        try await image?.delete()
    }
    // Toggles isFavorite boolean to true on the firestore database
    func favorite(_ post: Post) async throws {
        let favorite = Favorite(postID: post.id, userID: user.id)
        let document = favoritesReference.document(favorite.id)
        try await document.setData(from: favorite)
    }
    
    // Downloads all data from firestore database
     func fetchAllPosts() async throws -> [Post] {
         return try await fetchPosts(from: postsReference)
    }
    
    // Downloads isFavorite data
    func fetchFavoritePosts() async throws -> [Post] {
        let favorites = try await fetchFavorites()
        guard !favorites.isEmpty else { return [] }
        return try await postsReference
            .whereField("id", in: favorites.map(\.uuidString))
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Post.self)
            .map { post in
                post.setting(\.isFavorite, to: true)
            }
    }
    
    // Downloads data by author from firestore database
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("author.id", isEqualTo: author.id))
    }
    
    // Toggles isFavorite boolean to false on the firestore database
    func unfavorite(_ post: Post) async throws {
        let favorite = Favorite(postID: post.id, userID: user.id)
        let document = favoritesReference.document(favorite.id)
        try await document.delete()
    }
}

// MARK: - Extensions
extension PostsRepositoryProtocol {
    func canDelete(_ post: Post) -> Bool {
        post.author.id == user.id
    }
}

private extension PostsRepository {
    struct Favorite: Identifiable, Codable {
        var id: String {
            postID.uuidString + "-" + userID
        }
        let postID: Post.ID
        let userID: User.ID
    }
    
    func fetchFavorites() async throws -> [Post.ID] {
        return try await favoritesReference
            .whereField("userID", isEqualTo: user.id)
            .getDocuments(as: Favorite.self)
            .map(\.postID)
    }
    
    // Helper method to download data from firestore database
    func fetchPosts(from query: Query) async throws -> [Post] {
        let (posts, favorites) = try await (query.order(by: "timestamp", descending: true).getDocuments(as: Post.self), fetchFavorites())
        return posts.map { post in
            post.setting(\.isFavorite, to: favorites.contains(post.id))
        }
    }
}

private extension Post {
    func setting<T>(_ property: WritableKeyPath<Post, T>, to newValue: T) -> Post {
        var post = self
        post[keyPath: property] = newValue
        return post
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
