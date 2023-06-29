//
//  PostsList.swift
//  Socialcademy
//
//  Created by Angelo Delgado on 6/28/23.
//

import SwiftUI

struct PostsList: View {
    private var posts = [Post.testPost]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(posts) { post in
                if searchText.isEmpty || post.contains(searchText) {
                    PostRow(post: post)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Posts")
        }
    }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        PostsList()
    }
}
