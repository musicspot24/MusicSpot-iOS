//
//  Countdown.swift
//  MSCoreKit
//
//  Created by 이창준 on 9/28/24.
//

import Foundation

public struct Countdown<C: Clock> {
    let clock: C

    public init(clock: C) {
        self.clock = clock
    }
}
