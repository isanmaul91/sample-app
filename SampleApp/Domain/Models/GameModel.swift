//
//  GameModel.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 04/04/23.
//

import Foundation

struct GameModel: Codable, Equatable {
    let id: Int
    let backgroundImage: String
    let name: String
    let released: String
    let rating: Double
    let publishers: [PublisherModel]?
    let playtime: Int
    let descriptionRaw: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case released
        case rating
        case publishers
        case playtime
        case descriptionRaw = "description_raw"
        case backgroundImage = "background_image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        backgroundImage = try values.decodeIfPresent(String.self, forKey: .backgroundImage) ?? ""
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        released = try values.decodeIfPresent(String.self, forKey: .released) ?? ""
        rating = try values.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        playtime = try values.decodeIfPresent(Int.self, forKey: .playtime) ?? 0
        descriptionRaw = try values.decodeIfPresent(String.self, forKey: .descriptionRaw) ?? ""
        publishers = try values.decodeIfPresent([PublisherModel].self, forKey: .publishers)
    }
}
