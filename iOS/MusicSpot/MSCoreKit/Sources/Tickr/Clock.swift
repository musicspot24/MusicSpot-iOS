//
//  Clocks.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import Foundation

extension Clock {
    /// Create `Heartbeat` sequence. Start heartbeat by using `for` loop on returned sequence.
    ///
    /// > Example:
    /// > ```swift
    /// > let heartbeat = clock.heartbeat(every: .seconds(1), until: .seconds(180), maxBeats: 60)
    /// > var count = 0
    /// > for await _ in heartbeat {
    /// >     // count increase every 1 seconds for maximum 3 minutes or 60 beats.
    /// >     count += 1
    /// > }
    public func heartbeat(
        every duration: Self.Duration,
        until deadline: Self.Duration? = nil,
        maxBeats: Int? = nil
    ) -> Heartbeat<Self> {
        Heartbeat(clock: self, duration: duration, deadline: deadline, maxBeats: maxBeats)
    }

    /// Create `Countdown` sequence. Start countdown by using `for` loop on returned sequence.
    ///
    /// > Example:
    /// > ```swift
    /// > let countdown = clock.countdown(to: .seconds(3), repeat: 3)
    /// > var count = 0
    /// > for await _ in countdown {
    /// >     // takes 9 (3 × 3) seconds and count will be 3.
    /// >     count += 1
    /// >     print("Count: \(count)")
    /// > }
    /// ```
    public func countdown(
        duration: Self.Duration,
        repeat epochs: Int = 1
    ) -> Countdown<Self> {
        Countdown(clock: self, duration: duration, repeat: epochs)
    }

    /// Start countdown immediately for `duration` which is repeated by `repeat`. For every epoch, closure given as
    /// `checkpointer` will be executed.
    ///
    /// > Example:
    /// > ```swift
    /// > var count = 0
    /// > await clock.countdown(from: .seconds(2), repeat: 3) {
    /// >       // takes 6 (2 × 3) seconds and count will be 3.
    /// >       count += 1
    /// > }
    /// > ```
    public func countdown(
        from duration: Self.Duration,
        repeat epochs: Int = 1,
        checkpointer: (() -> Void)? = nil
    ) async {
        let countdown = Countdown(clock: self, duration: duration, repeat: epochs)

        for await _ in countdown {
            checkpointer?()
        }
    }

    /// Create `countdown` stream which yields value resulted from `update` closure. Start countdown by using `for` loop
    /// on returned stream.
    ///
    /// > Example:
    /// > ```swift
    /// > let countdown = clock.countdown(from: .seconds(3), repeat: 2, initialElement: 1) { partialResult in
    /// >     partialResult + 2
    /// > }
    /// >
    /// > var count = 0
    /// > for await current in countdown {
    /// >     // takes 6 (3 × 2) seconds yielding result from `partialResult + 2` as `current` for every epochs.
    /// >     count = current
    /// >     print(count)
    /// > }
    public func countdown<Element: Sendable>(
        from duration: Duration,
        repeat epochs: Int = 1,
        initialElement: Element,
        update: @Sendable @escaping (_ partialResult: Element) -> Element
    ) -> AsyncStream<Element> {
        AsyncStream { continuation in
            Task {
                let countdown = Countdown(clock: self, duration: duration, repeat: epochs)
                var currentElement = initialElement

                for await _ in countdown {
                    currentElement = update(currentElement)
                    continuation.yield(currentElement)
                }

                continuation.finish()
            }
        }
    }
}
