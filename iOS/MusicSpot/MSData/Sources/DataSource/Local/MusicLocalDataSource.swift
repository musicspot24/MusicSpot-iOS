//
//  MusicLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 5/18/24.
//

import SwiftData

import Entity

@Model
public final class MusicLocalDataSource: EntityConvertible {

    // MARK: Nested Types

    // MARK: Public

    public typealias Entity = Music

    // MARK: Properties

    // MARK: - Relationships

    public var journey: JourneyLocalDataSource?

    public let musicID: String
    public var title: String
    public var artist: String?
    public var albumCover: AlbumCover?

    // MARK: Lifecycle

    // MARK: - Entity Convertible

    public init(from entity: Music) {
        musicID = entity.id
        title = entity.title
        artist = entity.artist
        albumCover = entity.albumCover
    }

    // MARK: - Initializer

    init(musicID: String, title: String) {
        self.musicID = musicID
        self.title = title
    }

    // MARK: Functions

    public func toEntity() -> Music {
        Music(
            id: musicID,
            title: title,
            artist: artist,
            albumCover: albumCover
        )
    }

    public func isEqual(to entity: Music) -> Bool {
        musicID == entity.id
    }
}
