//
//  PublisherModel.swift
//  SampleApp
//
//  Created by Muhammad Ihsan Maula on 04/04/23.
//

import Foundation

struct PublisherModel: Codable, Equatable {
    var name: String = ""
    
    init() {}
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
