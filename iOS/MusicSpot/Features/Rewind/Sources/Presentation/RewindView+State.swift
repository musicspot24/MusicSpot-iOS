//
//  RewindView+State.swift
//  Presentation
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

import Entity

public struct RewindView {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(selectedJourney: Binding<Journey>) {
        _selectedJourney = selectedJourney
    }

    // MARK: Internal

    // MARK: - Global

    // MARK: - Shared

    @Binding var selectedJourney: Journey

    // MARK: - Local

    // Timer.TimerPublisher는 `ConnectablePublisher` -> `connect()`로 연결해줘야 share가 시작된다.
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var timerProgress: CGFloat = .zero

    @State var currentIndex: Int = .zero
    @State var contentOffsetX: CGFloat?

}
