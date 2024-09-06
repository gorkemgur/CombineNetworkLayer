//
//  NetworkManager.swift
//  networking
//
//  Created by Görkem Gür on 6.09.2024.
//

import Foundation
import Combine

protocol NetworkService {
    func request<T: Decodable>(with endpointPaths: EnpointsProtocol, responseType: T.Type) -> AnyPublisher<T, NetworkError>
}

final class NetworkManager: NetworkService {
    private let session = URLSession.shared
    private let tokenManager = TokenManager.sharedInstance
    
    func request<T: Decodable>(with endpointPaths: EnpointsProtocol, responseType: T.Type) -> AnyPublisher<T, NetworkError> {
        var urlRequest = endpointPaths.asURLRequest()
        
        if let accessToken = tokenManager.retrieveAccessToken() {
            urlRequest.addValue(accessToken, forHTTPHeaderField: "Access Token")
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                if (200...299).contains(httpResponse.statusCode) {
                    return data
                } else if httpResponse.statusCode == 401 {
                    throw NetworkError.unauthorizedError
                } else {
                    throw NetworkError.custom(errorMessage: String(data: data, encoding: .utf8) ?? "", errorCode: httpResponse.statusCode)
                }
            }
        // Check the errors if error as same as unauthorizedError create new publisher to renew token
            .tryCatch { [weak self] error -> AnyPublisher<Data, NetworkError> in
                guard let self = self else { throw NetworkError.unknown }
                if case NetworkError.unauthorizedError = error {
                    return self.renewAccessToken()
                    // Send waiting request after renew token
                        .flatMap { _ in self.request(with: endpointPaths, responseType: responseType) }
                        .tryMap { $0 as? Data ?? Data()}
                        .mapError { $0 as? NetworkError ?? NetworkError.custom(errorMessage: "Token Renew Error", errorCode: -1) }
                        .eraseToAnyPublisher()
                } else {
                    throw error
                }
            }
            .decode(type: responseType, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else {
                    return NetworkError.decodingError
                }
            }
            .eraseToAnyPublisher()
        
    }
}

extension NetworkManager {
    fileprivate func renewAccessToken() -> AnyPublisher<RenewTokenResponse, NetworkError> {
        return request(with: TokenPath.renewToken, responseType: RenewTokenResponse.self)
        // We can use map too but it's not good solution for this we don't need return same data
            .handleEvents(receiveOutput: { [weak self] response in
                self?.tokenManager.saveAccessToken(token: response.accessToken)
            })
            .mapError { [weak self] error -> NetworkError in
                if case NetworkError.unknown = error {
                    self?.tokenManager.deleteToken()
                }
                return error
            }
            .eraseToAnyPublisher()
    }
}
