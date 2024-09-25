//
//  SpotLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

@Model
public final class SpotLocalDataSource: EntityConvertible {

    // MARK: Nested Types

    // MARK: Public

    public typealias Entity = Spot

    // MARK: Properties

    // MARK: - Relationships

    public var journey: JourneyLocalDataSource?

    public let spotID: String
    public var coordinate: Coordinate
    public var timestamp: Date
    @Relationship(deleteRule: .cascade, inverse: \PhotoLocalDataSource.spot)
    public var photos: [PhotoLocalDataSource] = []

    // MARK: Lifecycle

    // MARK: - Entity Convertible

    public init(from entity: Spot) {
        spotID = entity.id
        coordinate = entity.coordinate
        timestamp = entity.timestamp
        photos = entity.photoURLs.map { PhotoLocalDataSource(from: $0) }
    }

    // MARK: Functions

    public func toEntity() -> Spot {
        Spot(
            id: spotID,
            coordinate: coordinate,
            timestamp: timestamp,
            photoURLs: photos.map { $0.toEntity() }
        )
    }

    public func isEqual(to entity: Spot) -> Bool {
        spotID == entity.id
    }
}
