//
//  RewindDripper.swift
//  Rewind
//
//  Created by 이창준 on 10/2/24.
//

import Foundation
import OSLog

import Dripper
import Entity
import Tickr

public struct RewindDripper: Dripper {

    // MARK: Nested Types

    @MainActor
    @Observable
    public final class State: Sendable {

        // MARK: Properties

        var heartbeat: Heartbeat<SuspendingClock>?

        var journey: Journey
        var items: [ImageItem]
        var currentItem: ImageItem.ID?
        var currentCardItem: ImageItem.ID?

        // MARK: Lifecycle

        public init(journey: Journey) {
            let clock = SuspendingClock()
            heartbeat = clock.heartbeat(every: .seconds(3))
            self.journey = journey
            items = journey.photoURLs.map { ImageItem(imageURL: $0) }
        }
    }

    public enum Action {
        case timerStarted
        case itemUpdated(ImageItem.ID)
        case cardItemUpdated(ImageItem.ID)
        case nextItem
        case timerStopped
    }

    // MARK: Computed Properties

    public var body: some DripperOf<Self> {
        Drip { state, action in
            switch action {
            case .timerStarted:
                guard let heartbeat = state.heartbeat else { return .none }

                return .run { pour in
                    for await _ in heartbeat {
                        pour(.nextItem)
                    }
                }

            case .itemUpdated(let item):
                guard state.currentCardItem != state.currentItem else {
                    return .none
                }

                state.currentCardItem = item
                return .none

            case .cardItemUpdated(let item):
                guard state.currentCardItem != state.currentItem else {
                    return .none
                }

                state.currentItem = item
                return .none

            case .nextItem:
                return .none

            case .timerStopped:
                state.heartbeat = nil
                return .none
            }
        }
    }

    // MARK: Lifecycle

    public init() { }

}
