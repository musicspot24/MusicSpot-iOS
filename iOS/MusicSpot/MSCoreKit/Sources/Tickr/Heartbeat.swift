//
//  Heartbeat.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import Foundation

public struct Heartbeat<C: Clock>: AsyncSequence {

    // MARK: Nested Types

    public struct HeartbeatIterator: AsyncIteratorProtocol {
        var clock: C
        let duration: C.Duration

        init(duration: C.Duration, clock: C) {
            self.clock = clock
            self.duration = duration
        }

        public mutating func next() async -> C.Instant? {
            do {
                try await clock.sleep(for: duration)
            } catch {
                return nil
            }

            return clock.now
        }
    }

    // MARK: Properties

    let clock: C
    let duration: C.Duration

    // MARK: Lifecycle

    init(duration: C.Duration, clock: C) {
        self.clock = clock
        self.duration = duration
    }

    // MARK: Functions

    public func makeAsyncIterator() -> HeartbeatIterator {
        HeartbeatIterator(duration: duration, clock: clock)
    }
}
