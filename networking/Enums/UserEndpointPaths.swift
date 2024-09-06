//
//  UserEndpointPaths.swift
//  networking
//
//  Created by Görkem Gür on 6.09.2024.
//

import Foundation

enum UserEndpointPaths: EnpointsProtocol {
    
    case login(email: String, password: String)
    case register
    
    var baseUrl: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .register:
            return "/register"
        }
    }
    
    var method: HTTPMethod? {
        switch self {
        case .login( _, _) , .register:
            return .post
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(let email, let password):
            return ["email" : email, "password": password]
        default:
            return nil
        }
    }
    
    var queryParameters: [URLQueryItem]? { return nil }
    
    var body: Encodable? { return nil }
    
}


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


