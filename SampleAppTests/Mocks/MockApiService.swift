//
//  MockApiService.swift
//  SampleAppTests
//
//  Created by Muhammad Ihsan Maula on 05/04/23.
//

import Foundation
@testable import SampleApp

class MockApiService: APIServiceProtocol {
    enum Status {
        case success
        case error
    }
    
    var mockGamesList: GamesListModel = .init()
    var mockGame: GameModel = .init()
    var mockErrorResponse: Error = RequestError.someError
    var status: Status = .success
    var isFetchGames: Bool = false
    var isSearchGames: Bool = false
    var isGetDetail: Bool = false
    
    func fetchGamesList(page: Int, completion: @escaping (GamesListModel?, Error?) -> Void) {
        switch status {
        case .success:
            completion(mockGamesList, nil)
        case .error:
            completion(nil, mockErrorResponse)
        }
        isFetchGames = true
    }
    
    func getGameDetail(id: Int, completion: @escaping (GameModel?, Error?) -> Void) {
        switch status {
        case .success:
            completion(mockGame, nil)
        case .error:
            completion(nil, mockErrorResponse)
        }
        isGetDetail = true
    }
    
    func search(search: String, page: Int, completion: @escaping (GamesListModel?, Error?) -> Void) {
        switch status {
        case .success:
            completion(mockGamesList, nil)
        case .error:
            completion(nil, mockErrorResponse)
        }
        isSearchGames = true
    }
}
