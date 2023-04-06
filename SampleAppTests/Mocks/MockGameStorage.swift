//
//  MockGameStorage.swift
//  SampleAppTests
//
//  Created by Muhammad Ihsan Maula on 06/04/23.
//

import Foundation
@testable import SampleApp

class MockGameStorage: GameStorage {
    enum Status {
        case success
        case error
    }
    
    var mockGamesList: [GameEntity] = []
    var mockGame: GameEntity = .init()
    var mockErrorResponse: GameStorageError = .cannotFetch
    var status: Status = .success
    
    override func getItems(completion: @escaping ([GameEntity]?, GameStorageError?) -> ()) {
        switch status {
        case .success:
            completion(mockGamesList, nil)
        case .error:
            completion(nil, mockErrorResponse)
        }
    }
    
    override func deleteFavoriteItem(
        gamesId: Int,
        completion: @escaping (String?, GameStorageError?) -> ())
    {
        switch status {
        case .success:
            completion("success", nil)
        case .error:
            completion(nil, mockErrorResponse)
        }
    }
    
    override func addFavoriteItem(
        game: GameModel, completion:
        @escaping (String?, GameStorageError?) -> ())
    {
        switch status {
        case .success:
            completion("success", nil)
        case .error:
            completion(nil, mockErrorResponse)
        }
    }
    
    override func checkFavoriteItem(
        gamesId: Int,
        completion: @escaping (GameEntity?, GameStorageError?) -> ())
    {
        switch status {
        case .success:
            completion(mockGame, nil)
        case .error:
            completion(nil, mockErrorResponse)
        }
    }
}
