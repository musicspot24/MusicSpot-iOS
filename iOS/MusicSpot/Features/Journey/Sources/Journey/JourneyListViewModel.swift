//
//  JourneyListViewModel.swift
//  Journey
//
//  Created by 이창준 on 11/23/23.
//

import Combine
import Foundation

import Entity
import MSLogger
import Repository

public final class JourneyListViewModel {

    // MARK: Nested Types

    // MARK: Public

    public enum Action {
        case viewNeedsLoaded
        case visibleJourneysDidUpdated([Journey])
    }

    public struct State {
        /// CurrentValue
        public var journeys = CurrentValueSubject<[Journey], Never>([])
    }

    // MARK: Properties

    public var state = State()

    // MARK: Private

    private let repository: JourneyRepository

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(repository: JourneyRepository) {
        self.repository = repository
    }

    // MARK: Functions

    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            #if DEBUG
            MSLogger.make(category: .journeyList).debug("View Did Load.")
            #endif

        case .visibleJourneysDidUpdated(let visibleJourneys):
            state.journeys.send(visibleJourneys)
        }
    }

}
