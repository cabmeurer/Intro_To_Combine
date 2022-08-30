//
//  NetworkingError.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/2/22.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case errorDecoding(String)
    case errorFromServer(String)
}

extension NetworkingError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return NSLocalizedString("invalidURL", comment: K.invalidURL.rawValue)
        case .errorDecoding(let message):
            return NSLocalizedString("errorDecoding", comment: message)
        case .errorFromServer(let message):
            return NSLocalizedString("errorFromServer", comment: message)
        }
    }
}
