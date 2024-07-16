//
//  Rewind+State.swift
//  Rewind
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

import Entity

public struct Rewind {
    // MARK: - Global

    // MARK: - Shared

    @Binding var selectedJourney: Journey

    // MARK: - Local

    // MARK: - Initializer

    public init(selectedJourney: Binding<Journey>) {
        _selectedJourney = selectedJourney
    }
}
