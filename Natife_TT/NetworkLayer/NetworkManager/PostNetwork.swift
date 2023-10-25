//
//  PostNetwork.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import Foundation

protocol PostNetwork {
    func fetchFeed (completition: @escaping (Response<FeedPost>) -> Void)
    
    func fetchPostWith (id: Int, completition: @escaping (Response<FullPost>) -> Void)
}
