//
//  PostRow.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 6/28/23.
//

import SwiftUI

struct PostRow: View {
    typealias DeleteAction = () async throws -> Void
    
    let post: Post
    let deleteAction: DeleteAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(post.authorName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(post.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
            }
            .foregroundColor(.gray)
            Text(post.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(post.content)
            HStack {
                Spacer()
                Button(role: .destructive, action: deletePost) {
                    Label("Delete", systemImage: "trash")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical)
    }
    
    private func deletePost() {
        Task {
            try! await deleteAction()
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(post: Post.testPost, deleteAction: {})
    }
}
