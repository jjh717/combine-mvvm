//
//  CommonNetworkError.swift
//  combine-mvvm
//
//  Created by Louis on 2021/11/24.
//

import Foundation
 
enum CommonNetworkError: Error {
    case urlRequest
    case decode
    case unknown
}

extension CommonNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlRequest:
            return "urlRequest error"
        case .decode:
            return "response decode error"
        case .unknown:
            return "unknown error"
        }
    }
}
