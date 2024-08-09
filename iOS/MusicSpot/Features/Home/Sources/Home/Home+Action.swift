//
//  Home+Action.swift
//  Home
//
//  Created by 이창준 on 4/20/24.
//

import Foundation

extension Home {

    // MARK: Nested Types

    // MARK: Internal

    enum Action {
        case startButtonDidTap
        case mapButtonDidTap
    }

    // MARK: Functions

    func perform(_ action: Action) {
        switch action {
        case .startButtonDidTap:
            handleStartButtonTap()
        case .mapButtonDidTap:
            isUsingStandardMap.toggle()
        }
    }

    // MARK: Private

    private func handleStartButtonTap() { }
}
