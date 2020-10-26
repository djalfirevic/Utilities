//
//  Track.swift
//  AsyncTesting
//
//  Created by Djuro Alfirevic on 24.10.2020.
//  Copyright © 2020 Djuro Alfirevic. All rights reserved.
//

import Foundation

struct SearchMediaResponse: Codable {
    
    // MARK: - Properties
    let results: [Track]
    
}

struct Track: Codable, Equatable {
    
    // MARK: - Properties
    let trackName: String?
    let artistName: String?
    
}
