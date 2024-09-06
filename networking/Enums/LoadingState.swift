//
//  LoadingState.swift
//  networking
//
//  Created by Görkem Gür on 6.09.2024.
//

import Foundation

enum LoadingState {
    case idle
    case loading
    case finished
    case failure(error: NetworkError)
}
