//
//  GamesListModel.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 04/04/23.
//

import Foundation

struct GamesListModel: Codable, Equatable {
    let results: [GameModel]?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([GameModel].self, forKey: .results)
    }
}
