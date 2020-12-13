//
//  API.swift
//  Networking
//
//  Created by Djuro on 12/13/20.
//

import Foundation

protocol API {
    func fetchPosts(_ completion: @escaping (Result<[Post], Error>) -> Void)
}
