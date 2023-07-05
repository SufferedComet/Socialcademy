//
//  CommentRow.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 7/2/23.
//

import SwiftUI

struct CommentRow: View {
    @ObservedObject var viewModel: CommentRowViewModel
    @State private var showConfirmationDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(viewModel.author.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(viewModel.timestamp.formatted())
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Text(viewModel.content)
                .font(.headline)
                .fontWeight(.regular)
        }
        .padding(5)
        .swipeActions {
            if viewModel.canDeleteComment {
                Button(role: .destructive) {
                    showConfirmationDialog = true
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
        .confirmationDialog("Are you sure you want to delete this comment?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: {
                viewModel.deleteComment()
            })
        }
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow(viewModel: CommentRowViewModel(comment: Comment.testComment, deleteAction: {}))
            .previewLayout(.sizeThatFits)
    }
}