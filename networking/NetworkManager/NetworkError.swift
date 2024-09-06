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
            return NSLocalizedString(
                "Error Decoding Data",
                comment: "")
        case .urlError:
            return NSLocalizedString(
                "URL Convert Error",
                comment: "")
        case .dataError:
            return NSLocalizedString(
                "Data Error",
                comment: "")
        case .encodingError:
            return NSLocalizedString(
                "Encoding Data Error",
                comment: "")
        case .unauthorizedError:
            return NSLocalizedString(
                "Unauthorized Token Error",
                comment: "")
        case .invalidResponse:
            return NSLocalizedString(
                "Invalid Response Error", 
                comment: "")
        case .unknown:
            return NSLocalizedString(
                "Unknown Error", 
                comment: "")
        case .custom(let errorMessage, let errorCode):
            return NSLocalizedString(
                "Error \(errorMessage) errorCode \(errorCode)",
                comment: "")
        }
    }
}
