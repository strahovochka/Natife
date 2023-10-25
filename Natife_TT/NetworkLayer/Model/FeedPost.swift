//
//  FeedPost.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import Foundation

struct FeedPost: Codable {
    
    var posts: [Post]
    
    struct Post: Codable {
        var postId: Int
        var timeshamp: Int
        var title: String
        var previewText: String
        var likesCount: Int
    }
}
