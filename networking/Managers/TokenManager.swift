//
//  TokenManager.swift
//  networking
//
//  Created by Görkem Gür on 6.09.2024.
//

import Foundation
import Combine

protocol TokenManagerService {
    func saveAccessToken(token: String?)
    func retrieveAccessToken() -> String?
    func deleteToken()
}

final class TokenManager: TokenManagerService {
    static let sharedInstance = TokenManager()
    private let userDefaults = UserDefaults.standard
    private let concurrentQueue = DispatchQueue(label: "com.networking.app", attributes: .concurrent)
    
    private init() {}
    
    func saveAccessToken(token: String?) {
        if let token = token {
            concurrentQueue.async(flags: .barrier) {
                self.setValue(value: token, key: .accessToken)
            }
        }
    }
    
    func retrieveAccessToken() -> String? {
        concurrentQueue.sync {
            self.getValue(for: .accessToken)
        }
    }
    
    func deleteToken() {
        concurrentQueue.async(flags: .barrier) {
            self.deleteValue(for: .accessToken)
        }
    }
    
    private func setValue(value: String, key: UserDefaultsKeys) {
        userDefaults.setValue(value, forKey: key.rawValue)
    }
    
    private func getValue(for key: UserDefaultsKeys) -> String {
        userDefaults.string(forKey: key.rawValue) ?? ""
    }
    
    private func deleteValue(for key: UserDefaultsKeys) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
