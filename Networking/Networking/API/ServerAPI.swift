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
        RestManager.shared.GET(from: "/posts") { result in
            completion(result)
        }
    }
    
}
