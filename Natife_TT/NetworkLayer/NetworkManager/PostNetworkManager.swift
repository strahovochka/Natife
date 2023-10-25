//
//  PostNetworkManager.swift
//  Natife_TT
//
//  Created by Jane Strashok on 25.10.2023.
//

import Foundation

class PostNetworkManager: PostNetwork {
    
    static let shared = PostNetworkManager()
    private let baseURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api"
    
    func fetchFeed(completition: @escaping (Response<FeedPost>) -> Void) {
        fetchRequest(.feed, completition: completition)
    }
    
    func fetchPostWith(id: Int, completition: @escaping (Response<FullPost>) -> Void) {
        fetchRequest(.post(id), completition: completition)
    }
    
    func fetchRequest <T: Codable> (_ postAPI: PostAPI, completition: @escaping (Response<T>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(postAPI.pass)") else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completition(.error("returned error"))
                return
            }
            
            guard let statusCode = ( response as? HTTPURLResponse)?.statusCode else { return }
            
            if statusCode <= 299 && statusCode >= 200 {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let items = try? decoder.decode(T.self, from: data) else {
                    completition(.error("Couldn't decode data"))
                    return
                }
                completition(.success(items))
            } else {
                completition(.error("Unsuccessful status code"))
            }
        }.resume()
    }
}
