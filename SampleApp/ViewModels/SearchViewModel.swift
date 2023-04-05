//
//  SearchViewModel.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 05/04/23.
//
import Foundation

protocol SearchViewModelProtocol {
    var gamesList: Observable<[GameModel]> { get }
    func getGamesList() -> [GameModel]
    func search(_ searchText: String)
    func loadMore()
}

class SearchViewModel: SearchViewModelProtocol {
    var gamesList: Observable<[GameModel]> = Observable(value: [])
    private var requestState: Observable<RequestState> = Observable(value: .ready)
    private var apiService: APIServiceProtocol
    private var pageNumber: Int = 1
    private var query: String = ""
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func search(_ searchText: String) {
        requestState.value = .loading
        if self.query != searchText {
            self.query = searchText
            pageNumber = 1
        }
        apiService.search(search: searchText, page: pageNumber, completion: { [weak self] resp, error in
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
            search(query)
        }
    }
    
    func getGamesList() -> [GameModel] {
        return gamesList.value
    }
}
