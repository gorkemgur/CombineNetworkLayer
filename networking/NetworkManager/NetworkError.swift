//
//  NetworkError.swift
//  networking
//
//  Created by Görkem Gür on 6.09.2024.
//

import Foundation

enum NetworkError: LocalizedError {
    case decodingError
    case urlError
    case dataError
    case encodingError
    case unauthorizedError
    case invalidResponse
    case custom(errorMessage: String, errorCode: Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "Error Decoding Data"
        case .urlError:
            return "URL Convert Error"
        case .dataError:
            return "Data Error"
        case .encodingError:
            return "Encoding Data Error"
        case .unauthorizedError:
            return "Unauthorized Token Error"
        case .invalidResponse:
            return "Invalid Response Error"
        case .unknown:
            return "Unknown Error"
        case .custom(let errorMessage, let errorCode):
            return "Error \(errorMessage) errorCode \(errorCode)"
        }
    }
}
