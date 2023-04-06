//
//  DetailViewModel.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 05/04/23.
//

import Foundation

protocol DetailViewModelProtocol {
    var requestState: Observable<RequestState> { get }
    var favoriteState: Observable<RequestState> { get }
    var backgroundImage: String { get }
    var name: String { get }
    var released: String { get }
    var rating: Double { get }
    var publisherName: String { get }
    var playtime: Int { get }
    var descriptionRaw: String { get }
    var isFavorite: Bool { get }
    func set(_ gameId: Int)
    func getGameDetail()
    func onTapLove()
}

class DetailViewModel: DetailViewModelProtocol {
    var requestState: Observable<RequestState> = Observable(value: .ready)
    var favoriteState: Observable<RequestState> = Observable(value: .ready)
    var backgroundImage: String = ""
    var name: String = ""
    var released: String = ""
    var rating: Double = 0
    var publisherName: String = ""
    var playtime: Int = 0
    var descriptionRaw: String = ""
    var isFavorite: Bool = false
    private var apiService: APIServiceProtocol
    private var gameStorage: GameStorage
    private var gameModel: GameModel?
    private var gameId: Int = 0
    
    init(apiService: APIServiceProtocol = APIService(),
         gameStorage: GameStorage = .shared) {
        self.apiService = apiService
        self.gameStorage = gameStorage
    }
    
    func set(_ gameId: Int) {
        self.gameId = gameId
    }
    
    func set(_ gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    private func setFavorite() {
        gameStorage.checkFavoriteItem(gamesId: gameId) { [weak self] resp, err in
            guard let ws = self else { return }
            if let _ = resp {
                ws.isFavorite = true
            } else {
                ws.isFavorite = false
            }
        }
    }
    
    func onTapLove() {
        if isFavorite {
            gameStorage.deleteFavoriteItem(gamesId: gameId) { [weak self] resp, err in
                guard let ws = self else { return }
                if let _ = resp {
                    ws.isFavorite = false
                    ws.favoriteState.value = .success
                }
            }
        } else {
            guard let game = gameModel else { return }
            gameStorage.addFavoriteItem(game: game) { [weak self] resp, err in
                guard let ws = self else { return }
                if let _ = resp {
                    ws.isFavorite = true
                    ws.favoriteState.value = .success
                }
            }
        }
    }
    
    func getGameDetail() {
        apiService.getGameDetail(id: gameId, completion: { [weak self] resp, error in
            guard let ws = self else { return }
            if let resp = resp {
                ws.mappingData(from: resp)
                ws.requestState.value = .success
            } else if let error = error {
                ws.requestState.value = .error
                print(error.localizedDescription)
            }
        })
    }
    
    func mappingData(from model: GameModel) {
        set(model)
        backgroundImage = model.backgroundImage
        name = model.name
        if let publisher = model.publishers[safe: 0] {
            publisherName = publisher.name
        }
        released = model.released
        rating = model.rating
        playtime = model.playtime
        descriptionRaw = model.descriptionRaw
        setFavorite()
    }
}
