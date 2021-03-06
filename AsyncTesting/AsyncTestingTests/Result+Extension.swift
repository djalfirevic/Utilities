//
//  Result+Ext.swift
//  AsyncTestingTests
//
//  Created by Djuro Alfirevic on 23.10.2020.
//  Copyright © 2020 Djuro Alfirevic. All rights reserved.
//

import Foundation

extension Result {
    var error: Failure? {
        switch self {
        case .failure(let error): return error
        default: return nil
        }
    }
    
    var value: Success? {
        switch self {
        case .success(let value): return value
        default: return nil
        }
    }
}
