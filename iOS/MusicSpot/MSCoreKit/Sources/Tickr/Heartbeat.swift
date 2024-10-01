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

        // MARK: Properties

        var clock: C
        let duration: C.Duration
        let deadline: C.Instant?

        // MARK: Lifecycle

        init(clock: C, duration: C.Duration, deadline: C.Duration?) {
            self.clock = clock
            self.duration = duration
            self.deadline = deadline.map { clock.now.advanced(by: $0) } ?? nil
        }

        // MARK: Functions

        public mutating func next() async -> C.Instant? {
            if let deadline, clock.now >= deadline {
                return nil
            }

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
    let deadline: C.Duration?

    // MARK: Lifecycle

    init(clock: C, duration: C.Duration, deadline: C.Duration? = nil) {
        self.clock = clock
        self.duration = duration
        self.deadline = deadline
    }

    // MARK: Functions

    public func makeAsyncIterator() -> HeartbeatIterator {
        HeartbeatIterator(clock: clock, duration: duration, deadline: deadline)
    }
}
