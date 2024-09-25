//
//  PhotoLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

@Model
public final class PhotoLocalDataSource: EntityConvertible {

    // MARK: Nested Types

    // MARK: Public

    public typealias Entity = URL

    // MARK: Properties

    // MARK: - Relationships

    public var spot: SpotLocalDataSource?

    public var url: URL

    // MARK: Lifecycle

    // MARK: - Entity Convertible

    public init(from entity: URL) {
        url = entity
    }

    // MARK: - Initializer

    init(url: URL) {
        self.url = url
    }

    // MARK: Functions

    public func toEntity() -> URL {
        url
    }

    public func isEqual(to entity: URL) -> Bool {
        url == entity
    }
}
