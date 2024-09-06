//
//  EndpointsProtocol.swift
//  networking
//
//  Created by Görkem Gür on 6.09.2024.
//

import Foundation

protocol EnpointsProtocol {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod? { get }
    var headers: [String: String]? { get }
    var queryParameters: [URLQueryItem]? { get }
    var body: Encodable? { get }
}

extension EnpointsProtocol {
    var path: String {
        return ""
    }
    
    var method: HTTPMethod? {
        .post
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var queryParameters: [URLQueryItem]? {
        nil
    }
    
    var body: Encodable? {
        nil
    }
    
    func asURLRequest() -> URLRequest {
        var components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: true)
        if let queryParameters = queryParameters {
            components?.queryItems = queryParameters
        }
        
        var request = URLRequest(url: components?.url ?? baseUrl)
        request.httpMethod = method?.rawValue
        request.allHTTPHeaderFields = headers
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                debugPrint("Request Body Convert Error")
            }
        }
        
        return request
    }
}
