//
//  MusicService.swift
//  AsyncTesting
//
//  Created by Djuro Alfirevic on 2/28/20.
//  Copyright © 2020 Djuro Alfirevic. All rights reserved.
//

import Foundation

protocol HTTPClient {
    func execute(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

struct MusicService {
    
    // MARK: - Properties
    let httpClient: HTTPClient
    
    // MARK: - Public API
    func search(_ term: String, completion: @escaping (Result<[Track], Error>) -> Void) {
        httpClient.execute(request: .search(term: term)) { result in
            completion(self.parse(result))
        }
    }
    
    // MARK: - Private API
    private func parse(_ result: Result<Data, Error>) -> Result<[Track], Error> {
        result.flatMap { data in
            Result { try JSONDecoder().decode(SearchMediaResponse.self, from: data).results }
        }
    }
    
}

class RealHTTPClient: HTTPClient {
    
    // MARK: - Public API
    func execute(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(error!))
                }
            }
        }.resume()
    }
    
}
