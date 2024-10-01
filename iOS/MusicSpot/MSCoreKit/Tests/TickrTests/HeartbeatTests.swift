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

    @Test("Heartbeat can iterate correctly", arguments: [3, 5, 10])
    func iterateCorrectly(iteration: Int) async throws {
        var count: Int = .zero

        await confirmation(expectedCount: iteration) { confirmation in
            for await _ in clock.heartbeat(every: .seconds(1), until: .seconds(iteration)) {
                count += 1
                Logger().info("\(count)")
                confirmation.confirm()
            }
        }

        #expect(count == iteration)
    }
}
