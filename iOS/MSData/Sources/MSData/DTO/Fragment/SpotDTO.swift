//
//  SpotDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct SpotDTO: Codable {
    
    public let journeyID: String?
    public let coordinate: CoordinateDTO
    public let timestamp: Date
    public let photoURL: URL
    
    enum CodingKeys: String, CodingKey {
        case journeyID = "journeyId"
        case coordinate
        case timestamp
        case photoURL = "photoUrl"
    }
    
}
