//
//  TokenPath.swift
//  networking
//
//  Created by Görkem Gür on 6.09.2024.
//

import Foundation

enum TokenPath: EnpointsProtocol {
    case renewToken
    
    var baseUrl: URL {
        URL(string: "")!
    }
}
