//
//  MockAPI.swift
//  Networking
//
//  Created by Djuro on 12/13/20.
//

import Foundation

final class MockAPI {
    
    // MARK: - Properties
    private var payload = [Post]()
    
    // MARK: - Initializer
    init() {
        do {
            try configureData()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Private API
    private func configureData() throws {
        guard let path = Bundle.main.path(forResource: "posts", ofType: "json") else { return }
        
        let url = URL(fileURLWithPath: path)
        let decoder = JSONDecoder()
        
        do {
            let data = try Data(contentsOf: url)
            
            payload = try decoder.decode([Post].self, from: data)
            
            print("Parsing successful: \(payload.count) element(s) parsed.")
        } catch {
            print("Parsing error: \(error.localizedDescription)")
            
            throw error
        }
    }
    
}

extension MockAPI: API {
    
    // MARK: - API
    func fetchPosts(_ completion: @escaping (Result<[Post], Error>) -> Void) {
        completion(.success(payload))
    }
    
}
