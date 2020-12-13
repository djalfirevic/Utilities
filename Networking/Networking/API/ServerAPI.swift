//
//  ServerAPI.swift
//  Networking
//
//  Created by Djuro on 12/13/20.
//

import Foundation

final class ServerAPI {}

extension ServerAPI: API {
    
    // MARK: - API
    func fetchPosts(_ completion: @escaping (Result<[Post], Error>) -> Void) {
//        RestManager.shared.GET(from: "/posts") { result in
//            completion(result)
//        }
        
        URLSession.shared.request(Endpoint.posts) { (data, response, error) in
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let object = try decoder.decode([Post].self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(.success(object))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
                print("Decoding error: \(error)")
            }
        }
    }
    
}
