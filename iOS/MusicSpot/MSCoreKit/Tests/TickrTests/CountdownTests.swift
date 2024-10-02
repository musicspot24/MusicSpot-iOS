//
//  CountdownTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import OSLog
import Testing

import Tickr

struct CountdownTests {

    // MARK: Properties

    let clock: SuspendingClock

    // MARK: Lifecycle

    init() async throws {
        clock = .suspending
    }

    // MARK: Functions

    @Test("Countdown using sequence and for loop", arguments: [3, 5, 10])
    func countdownWithSequence(iteration: Int) async throws {
        var count: Int = .zero

        let countdown = clock.countdown(duration: .seconds(2), repeat: iteration)
        await confirmation(expectedCount: iteration) { confirmation in
            for await _ in countdown {
                count += 1
                confirmation.confirm()
            }
        }

        #expect(count == iteration)
    }

    @Test("Countdown with no yielded value", arguments: [3, 5, 10])
    func countdownWithNoYield(iteration: Int) async throws {
        var count: Int = .zero

        await confirmation(expectedCount: iteration) { confirmation in
            await clock.countdown(from: .seconds(2), repeat: iteration) {
                count += 1
                confirmation.confirm()
            }
        }

        #expect(count == iteration)
    }

    @Test("Countdown with yielded value", arguments: [3, 5, 10])
    func countdownWithYield(repeat: Int) async throws {
        let countdown = clock.countdown(from: .seconds(2), repeat: `repeat`, initialElement: 0) { partialResult in
            partialResult + 2
        }

        var count: Int = .zero
        await confirmation(expectedCount: `repeat`) { confirmation in
            for await current in countdown {
                count += 1
                Logger().info("Current: \(current), Count: \(count)")
                #expect(current == count * 2)
                confirmation.confirm()
            }
        }
    }
}
