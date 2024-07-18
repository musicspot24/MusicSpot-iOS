//
//  Rewind+State.swift
//  Rewind
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

import Entity

public struct Rewind {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(selectedJourney: Binding<Journey>) {
        _selectedJourney = selectedJourney
    }

    // MARK: Internal

    // MARK: - Constants

    enum Metric {
        static let progressSpacing: CGFloat = 5.0
        static let progressHeight: CGFloat = 1.5
        /// 사진 하나의 출력 시간(s)
        static let progressDuration: CGFloat = 3.0
    }

    // MARK: - Global

    // MARK: - Shared

    @Binding var selectedJourney: Journey

    // MARK: - Local

    // Timer.TimerPublisher는 `ConnectablePublisher` -> `connect()`로 연결해줘야 share가 시작된다.
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var timerProgress: CGFloat = .zero

}
