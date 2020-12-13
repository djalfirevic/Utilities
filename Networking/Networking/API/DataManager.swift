//
//  DataManager.swift
//  Networking
//
//  Created by Djuro on 12/13/20.
//

import Foundation

final class DataManager {
    
    // MARK: - Properties
    private let api: API
    
    // MARK: - Initializers
    init(api: API = ServerAPI()) {
        self.api = api
    }
    
    // MARK: - Public API
    func fetchPosts(_ completion: @escaping (Result<[Post], Error>) -> Void) {
        api.fetchPosts(completion)
    }
    
}
