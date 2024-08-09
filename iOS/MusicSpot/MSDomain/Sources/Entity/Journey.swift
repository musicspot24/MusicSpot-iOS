//
//  Journey.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

// MARK: - Journey

public struct Journey: Identifiable {

    // MARK: Properties

    public let id: String
    public private(set) var title: String?
    public private(set) var date: Timestamp
    public private(set) var spots: [Spot]
    public private(set) var coordinates: [Coordinate]
    public private(set) var playlist: [Music]
    public private(set) var isTraveling: Bool

    // MARK: Computed Properties

    /// 여정에 저장된 모든 사진/영상의 URL
    // TODO: 영상 추가 후 네이밍 변경
    public var photoURLs: [URL] {
        spots.flatMap(\.photoURLs)
    }

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        id: String,
        title: String?,
        date: Timestamp,
        coordinates: [Coordinate],
        spots: [Spot],
        playlist: [Music],
        isTraveling: Bool)
    {
        self.id = id
        self.title = title
        self.date = date
        self.spots = spots
        self.coordinates = coordinates
        self.playlist = playlist
        self.isTraveling = isTraveling
    }

    // MARK: Public

}

// MARK: - Mutating Functions

extension Journey {
    public mutating func appendCoordinates(_ coordinates: [Coordinate]) {
        self.coordinates = self.coordinates + coordinates
    }

    public mutating func finish() {
        date.end = .now
        isTraveling = false
    }
}

// MARK: Hashable

extension Journey: Hashable {

    // MARK: Static Functions

    public static func == (lhs: Journey, rhs: Journey) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: Functions

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Sample

extension Journey {
    public static let sample = Journey(
        id: UUID().uuidString,
        title: "Sample",
        date: .init(start: .now),
        coordinates: [],
        spots: [
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum2/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum3/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum4/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum5/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum6/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum7/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum8/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum9/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum10/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum11/600/800")!,
            ]),
        ],
        playlist: [],
        isTraveling: true)
}

// MARK: CustomStringConvertible

extension Journey: CustomStringConvertible {
    public var description: String {
        """
        Journey
        - title: \(title ?? "")
        - state: \(isTraveling ? "🏃‍♂️ Traveling" : "😴 Finished")
        - date:
          - start: \(date.start)
          - end: \(date.end ?? .distantFuture)
        """
    }
}
