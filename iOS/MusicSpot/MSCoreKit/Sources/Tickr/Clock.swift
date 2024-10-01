//
//  Clocks.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import Foundation

extension Clock {
    public func heartbeat(
        every duration: Self.Duration,
        until deadline: Self.Duration? = nil
    ) -> Heartbeat<Self> {
        Heartbeat(clock: self, duration: duration, deadline: deadline)
    }

    public func countdown(
        to duration: Self.Duration,
        _ task: @escaping () -> Void
    ) -> Countdown<Self> {
        let _ = duration
        let _ = task
        return Countdown(clock: self)
    }
}
