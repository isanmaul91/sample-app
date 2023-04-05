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
    var rating: String { get }
    var publisherName: String { get }
    var playtime: String { get }
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
    var rating: String = ""
    var publisherName: String = ""
    var playtime: String = ""
    var descriptionRaw: String = ""
    var isFavorite: Bool = false
    private var apiService: APIServiceProtocol
    private var game: GameModel?
    private var gameStorage: GameStorage
    private var gameId: Int = 0
    
    init(apiService: APIServiceProtocol = APIService(),
         gameStorage: GameStorage = .shared) {
        self.apiService = apiService
        self.gameStorage = gameStorage
    }
    
    func set(_ gameId: Int) {
        self.gameId = gameId
    }
    
    private func setFavorite() {
        isFavorite = false
        gameStorage.getItems { [weak self] items, error in
            guard let ws = self else { return }
            if let items = items {
                for item in items {
                    if item.id == Int64(ws.gameId) {
                        ws.isFavorite = true
                        break
                    }
                }
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
            guard let game = game else { return }
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
        game = model
        backgroundImage = model.backgroundImage
        name = model.name
        if let publisher = model.publishers[safe: 0] {
            publisherName = publisher.name
        }
        released = "Release date \(model.released)"
        rating = "\(model.rating)"
        playtime = "\(model.playtime) played"
        descriptionRaw = model.descriptionRaw
        setFavorite()
    }
}
