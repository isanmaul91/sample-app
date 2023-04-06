//
//  FavoriteViewModel.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 05/04/23.
//

import Foundation

protocol FavoriteViewModelProtocol {
    var gamesList: Observable<[GameEntity]> { get }
    func getGamesList() -> [GameEntity]
    func fetchGamesList()
}

class FavoriteViewModel: FavoriteViewModelProtocol {
    var gamesList: Observable<[GameEntity]> = Observable(value: [])
    var requestState: Observable<RequestState> = Observable(value: .ready)
    private var gameStorage: GameStorage
    
    init(gameStorage: GameStorage = .shared) {
        self.gameStorage = gameStorage
    }
    
    func fetchGamesList() {
        gameStorage.getItems { [weak self] resp, err in
            guard let ws = self else { return }
            if let resp = resp {
                ws.requestState.value = .success
                ws.gamesList.value = resp
            } else if let error = err {
                ws.requestState.value = .error
                print(error.localizedDescription)
            }
        }
    }
    
    func getGamesList() -> [GameEntity] {
        return gamesList.value
    }
}
