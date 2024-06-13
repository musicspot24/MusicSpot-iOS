//
//  SpotLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

@Model
public final class SpotLocalDataSource: EntityConvertible {
    public typealias Entity = Spot

    // MARK: - Relationships

    public var journey: JourneyLocalDataSource?

    // MARK: - Properties

    public var coordinate: Coordinate
    public var timestamp: Date
    @Relationship(deleteRule: .cascade, inverse: \PhotoLocalDataSource.spot)
    public var photos: [PhotoLocalDataSource] = []

    // MARK: - Entity Convertible

    public init(from entity: Spot) {
        self.coordinate = entity.coordinate
        self.timestamp = entity.timestamp
        self.photos = entity.photoURLs.map { PhotoLocalDataSource(from: $0) }
    }

    public func toEntity() -> Spot {
        return Spot(
            coordinate: self.coordinate,
            timestamp: self.timestamp,
            photoURLs: self.photos.map { $0.toEntity() }
        )
    }
}
