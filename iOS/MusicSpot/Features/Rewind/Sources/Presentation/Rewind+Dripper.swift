//
//  RewindDripper.swift
//  Rewind
//
//  Created by 이창준 on 8/13/24.
//

import Observation

import Dripper

struct Rewind: Dripper {
    @Observable
    final class State {
        let name = ""
    }

    enum Action {
        case hello
    }

    var body: some DripperOf<Self> {
        Drip { state, action in
            switch action {
            case .hello:
                state
            }
        }
    }
}
