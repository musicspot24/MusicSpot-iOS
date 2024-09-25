//
//  RewindService.swift
//  Service
//
//  Created by 이창준 on 7/26/24.
//

import Combine
import CoreGraphics
import Entity
import Foundation
import Observation

@Observable
public final class RewindService {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        journey: Journey,
        timerInterval: CGFloat = 0.1,
        duration: CGFloat = 5.0)
    {
        selectedJourney = journey
        self.timerInterval = timerInterval
        progressDuration = duration
        timer = Timer
            .TimerPublisher(interval: timerInterval, runLoop: .main, mode: .common)
            .autoconnect()
    }

    // MARK: Functions

    // MARK: Public

    // MARK: Properties

    public var selectedJourney: Journey

    public var timerInterval: CGFloat
    public var progressDuration: CGFloat

    // Timer.TimerPublisher는 `ConnectablePublisher` -> `connect()`로 연결해줘야 share가 시작된다.
    /// `@Observable` 매크로를 사용하는 클래스에서 `package` 접근제어자를 사용하지 못하는 버그가 있습니다.
    ///
    /// > ToDo: Fix 버전 배포 후 수정 \
    /// 🔗 [`@Observable` + `package`  버그](https://github.com/swiftlang/swift/issues/71060)
    public var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    public var timerProgress: CGFloat = .zero

    // MARK: Package

    package func startProgress() {
        timer = Timer
            .TimerPublisher(interval: timerInterval, runLoop: .main, mode: .common)
            .autoconnect()
    }

    package func progressTimer(progress: CGFloat? = nil) {
        if let progress {
            timerProgress += progress
        } else {
            timerProgress += (timerInterval / progressDuration)
        }
    }

    // MARK: Private

    private var cancellables: Set<AnyCancellable> = []

}
