//
//  HomeViewModel.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 04/04/23.
//

import Foundation

protocol HomeViewModelProtocol {
    var gamesList: Observable<[GameModel]> { get }
    func getGamesList() -> [GameModel]
    func fetchGamesList()
    func loadMore()
}

class HomeViewModel: HomeViewModelProtocol {
    var gamesList: Observable<[GameModel]> = Observable(value: [])
    private var requestState: Observable<RequestState> = Observable(value: .ready)
    private var apiService: APIServiceProtocol
    private var pageNumber: Int = 1
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchGamesList() {
        apiService.fetchGamesList(page: pageNumber, completion: { [weak self] resp, error in
            guard let ws = self else { return }
            if let resp = resp {
                ws.requestState.value = .success
                if ws.pageNumber == 1 {
                    ws.gamesList.value = resp.results ?? []
                } else {
                    ws.gamesList.value.append(contentsOf: resp.results ?? [])
                }
                ws.pageNumber += 1
            } else if let error = error {
                ws.requestState.value = .error
                print(error.localizedDescription)
            }
        })
    }
    
    func loadMore() {
        if requestState.value != .loading {
            fetchGamesList()
        }
    }
    
    func getGamesList() -> [GameModel] {
        return gamesList.value
    }
}
