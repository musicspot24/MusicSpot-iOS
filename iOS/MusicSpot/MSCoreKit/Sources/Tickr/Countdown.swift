//
//  Countdown.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import Foundation

public struct Countdown<C: Clock>: AsyncSequence, Sendable {

    // MARK: Nested Types

    public struct CountdownItrator: AsyncIteratorProtocol {

        // MARK: Properties

        let clock: C
        let duration: C.Duration
        let epochs: Int
        var currentEpoch: Int = .zero

        // MARK: Lifecycle

        init(clock: C, duration: C.Duration, epochs: Int) {
            self.clock = clock
            self.duration = duration
            self.epochs = epochs
        }

        // MARK: Functions

        public mutating func next() async -> C.Instant? {
            defer { currentEpoch += 1 }
            if currentEpoch >= epochs {
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
    let epochs: Int

    // MARK: Lifecycle

    public init(clock: C, duration: C.Duration, repeat epochs: Int) {
        self.clock = clock
        self.duration = duration
        self.epochs = epochs
    }

    // MARK: Functions

    public func makeAsyncIterator() -> CountdownItrator {
        CountdownItrator(clock: clock, duration: duration, epochs: epochs)
    }
}
