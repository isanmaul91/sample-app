//
//  APIService.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 04/04/23.
//

import Foundation

protocol APIServiceProtocol {
    func fetchGamesList(page: Int, completion: @escaping (_ resp: GamesListModel?, _ error: Error?) -> Void)
    func getGameDetail(id: Int, completion: @escaping (_ resp: GameModel?, _ error: Error?) -> Void)
    func search(search: String, page: Int, completion: @escaping (_ resp: GamesListModel?, _ error: Error?) -> Void)
}

class APIService: APIServiceProtocol {
    
    
    func fetchGamesList(page: Int, completion: @escaping (GamesListModel?, Error?) -> Void) {
        let urlString: String = "\(Api.BASE_URL)?\(ParameterKeys.PAGE)=\(page)&\(ParameterKeys.PAGE_SIZE)=10&\(ParameterKeys.API_KEY)=\(Api.KEY)"
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, resp, err in
            guard let data = data else {
                completion(nil, err)
                return
            }
            let decoder = JSONDecoder()
            do {
                let gamesListModel: GamesListModel = try decoder.decode(GamesListModel.self, from: data)
                completion(gamesListModel, nil)
            } catch {
                completion(nil, err)
            }
        }

        task.resume()
    }
    
    func getGameDetail(id: Int, completion: @escaping (GameModel?, Error?) -> Void) {
        let urlString: String = "\(Api.BASE_URL)/\(id)?\(ParameterKeys.API_KEY)=\(Api.KEY)"
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, resp, err in
            guard let data = data else {
                completion(nil, err)
                return
            }
            let decoder = JSONDecoder()
            do {
                let gameModel: GameModel = try decoder.decode(GameModel.self, from: data)
                completion(gameModel, nil)
            } catch {
                completion(nil, err)
            }
        }

        task.resume()
    }
    
    func search(search: String, page: Int, completion: @escaping (GamesListModel?, Error?) -> Void) {
        var urlString: String = "\(Api.BASE_URL)?\(ParameterKeys.SEARCH)=\(search)&\(ParameterKeys.PAGE)=\(page)&\(ParameterKeys.PAGE_SIZE)=10&\(ParameterKeys.API_KEY)=\(Api.KEY)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, resp, err in
            guard let data = data else {
                completion(nil, err)
                return
            }
            let decoder = JSONDecoder()
            do {
                let gamesListModel: GamesListModel = try decoder.decode(GamesListModel.self, from: data)
                completion(gamesListModel, nil)
            } catch {
                completion(nil, err)
            }
        }

        task.resume()
    }
}
