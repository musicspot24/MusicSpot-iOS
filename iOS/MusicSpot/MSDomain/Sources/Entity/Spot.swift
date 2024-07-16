//
//  Spot.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

// MARK: - Spot

public struct Spot: Identifiable {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        id: String,
        coordinate: Coordinate,
        timestamp: Date,
        photoURLs: [URL])
    {
        self.id = id
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoURLs = photoURLs
    }

    // MARK: Public

    // MARK: - Properties

    public let id: String
    public let coordinate: Coordinate
    public let timestamp: Date
    public let photoURLs: [URL]

}

// MARK: CustomStringConvertible

extension Spot: CustomStringConvertible {
    public var description: String {
        """
        Coordinate:
          - latitude: \(coordinate.latitude)
          - longitude: \(coordinate.longitude)
        PhotoURLs
          - x\(photoURLs.count)
        Timestamp
          - \(timestamp)
        """
    }
}
