//
//  CountdownTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import Testing

import Tickr

struct CountdownTests {
    let clock: SuspendingClock

    init() async throws {
        clock = .suspending
    }

    @Test
    func example() async throws { }
}
