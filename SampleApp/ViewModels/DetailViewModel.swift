//
//  DetailViewModel.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 05/04/23.
//

import Foundation

protocol DetailViewModelProtocol {
    var requestState: Observable<RequestState> { get }
    func set(_ gameId: Int)
    func getGameDetail()
}

class DetailViewModel: DetailViewModelProtocol {
    var requestState: Observable<RequestState> = Observable(value: .ready)
    private var apiService: APIServiceProtocol
    private var gameId: Int = 0
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func set(_ gameId: Int) {
        self.gameId = gameId
    }
    
    func getGameDetail() {
        apiService.getGameDetail(id: gameId, completion: { [weak self] resp, error in
            guard let ws = self else { return }
            if let resp = resp {
                ws.requestState.value = .success
                // TO DO
            } else if let error = error {
                ws.requestState.value = .error
                print(error.localizedDescription)
            }
        })
    }
}
