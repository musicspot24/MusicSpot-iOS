//
//  RewindService.swift
//  Service
//
//  Created by 이창준 on 7/26/24.
//

import Combine
import Entity
import Foundation
import Observation

@Observable
public final class RewindService {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(journey: Journey) {
        self.selectedJourney = journey
    }

    // MARK: Public

    public var selectedJourney: Journey

    // Timer.TimerPublisher는 `ConnectablePublisher` -> `connect()`로 연결해줘야 share가 시작된다.
    /// `@Observable` 매크로를 사용하는 클래스에서 `package` 접근제어자를 사용하지 못하는 버그가 있습니다.
    ///
    /// > ToDo: Fix 버전 배포 후 수정 \
    /// 🔗 [`@Observable` + `package`  버그](https://github.com/swiftlang/swift/issues/71060)
    public var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    public var timerProgress: CGFloat = .zero

}
