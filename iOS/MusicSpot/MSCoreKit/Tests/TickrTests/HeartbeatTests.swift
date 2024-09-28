//
//  HeartbeatTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import OSLog
import Testing

import Tickr

struct HeartbeatTests {
    let clock: Clocks

    init() async throws {
        clock = Clocks()
    }

    @Test
    func example() async throws {
        var count = 0

        for await _ in clock.heartbeat(every: .seconds(1)) {
            count += 1
            Logger().info("\(count)")
        }
    }
}
