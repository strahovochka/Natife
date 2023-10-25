//
//  PostAPI.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import Foundation

enum PostAPI {
    case feed
    case post(Int)
    
    var pass: String {
        switch self {
        case .feed:
            return "/main.json"
        case let .post(id):
            return "/posts/\(id).json"
        }
    }
}
