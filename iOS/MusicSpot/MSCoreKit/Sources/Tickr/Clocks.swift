//
//  Clocks.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import Foundation

public struct Clocks {
    public init() { }

    public func heartbeat(
        every duration: Duration,
        upto deadline: Duration? = nil
    ) -> Heartbeat<ContinuousClock> {
        Heartbeat(duration: duration, deadline: deadline, clock: .continuous)
    }

    public func countdown(to duration: Duration) -> Countdown<ContinuousClock> {
        let _ = duration
        return Countdown(clock: .continuous)
    }
}
