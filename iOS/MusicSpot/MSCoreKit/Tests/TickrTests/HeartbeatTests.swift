//
//  HeartbeatTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import OSLog
import Testing

import Tickr

@Suite("Heartbeat Tests")
struct HeartbeatTests {

    // MARK: Properties

    let clock: SuspendingClock

    // MARK: Lifecycle

    init() async throws {
        clock = .suspending
    }

    // MARK: Functions

    @Test("Heartbeat stops by deadline", arguments: [3, 5, 10])
    func stopBeatByDeadlineTime(iteration: Int) async throws {
        var count: Int = .zero

        await confirmation(expectedCount: iteration) { confirmation in
            for await _ in clock.heartbeat(every: .seconds(1), until: .seconds(iteration)) {
                count += 1
                Logger().info("Count: \(count)")
                confirmation.confirm()
            }
        }

        #expect(count == iteration)
    }

    @Test("Heartbeat stops by maximum beats", arguments: [5, 10, 15])
    func stopBeatByMaximumBeats(maxBeats: Int) async throws {
        var count: Int = .zero

        await confirmation(expectedCount: maxBeats) { confirmation in
            for await _ in clock.heartbeat(every: .seconds(1), maxBeats: maxBeats) {
                count += 1
                Logger().info("Count: \(count)")
                confirmation.confirm()
            }
        }

        #expect(count == maxBeats)
    }

    @Test("Hearbeat stops reaches deadline or maxBeats", arguments: [3, 10, 5], [5, 10, 15])
    func stopBeatsByDeadlineOrMaximumBeats(until deadline: Int, maxBeats: Int) async throws {
        var count: Int = .zero

        await confirmation(expectedCount: min(deadline, maxBeats)) { confirmation in
            for await _ in clock.heartbeat(
                every: .seconds(1),
                until: .seconds(deadline),
                maxBeats: maxBeats
            ) {
                count += 1
                Logger().info("Count: \(count)")
                confirmation.confirm()
            }
        }

        #expect(count == min(deadline, maxBeats))
    }
}
