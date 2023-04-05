//
//  Constants.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 04/04/23.
//

import Foundation

struct Api {
    static let BASE_URL = "https://api.rawg.io/api/games"
    static let KEY = "2e086d7931ff43039d8118255901b87b"
}

struct ParameterKeys {
    static let API_KEY = "key"
    static let PAGE = "page"
    static let PAGE_SIZE = "page_size"
    static let SEARCH = "search"
}

enum RequestState {
    case ready
    case loading
    case success
    case error
}

typealias VoidClosure = () -> Void

enum GameStorageError: Error {
    case cannotFetch
    case cannotSave
    case cannotRemove
    case cannotFind
}

enum RequestError: Error {
    case someError
}
