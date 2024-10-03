//
//  RewindDripper.swift
//  Rewind
//
//  Created by 이창준 on 10/2/24.
//

import Foundation

import Dripper
import Entity
import Tickr

public struct RewindDripper: Dripper {

    // MARK: Nested Types

    @Observable
    public final class State {

        // MARK: Properties

        var selectedJourney: Journey

        // MARK: Lifecycle

        public init(selectedJourney: Journey) {
            self.selectedJourney = selectedJourney
        }
    }

    public enum Action {
        case viewNeedsLoaded
    }

    // MARK: Properties

    private let clock = ContinuousClock()

    // MARK: Computed Properties

    public var body: some DripperOf<Self> {
        Drip { _, action in
            switch action {
            case .viewNeedsLoaded:
                let heartbeat = clock.heartbeat(every: .seconds(1))
                return .run { _ in
                    for await _ in heartbeat { }
                }
            }
        }
    }

    // MARK: Lifecycle

    public init() { }

}
