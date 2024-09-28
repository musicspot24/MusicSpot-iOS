//
//  Clocks.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import Foundation

public struct Clocks {
    public init() { }

    public func heartbeat(every duration: Duration) -> Heartbeat<ContinuousClock> {
        Heartbeat(duration: duration, clock: .continuous)
    }

    public func countdown(to _: Duration) -> Countdown<ContinuousClock> {
        Countdown(clock: .continuous)
    }
}
