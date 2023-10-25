//
//  FullPost.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import Foundation

struct FullPost: Codable {
    
    var post: Post
    
    struct Post: Codable {
        var postId: Int
        var timeshamp: Int
        var title: String
        var text: String
        var postImage: String
        var likesCount: Int
    }
}
