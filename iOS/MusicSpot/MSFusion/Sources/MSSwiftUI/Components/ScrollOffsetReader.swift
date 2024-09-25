//
//  ScrollOffsetTracker.swift
//  MSSwiftUI
//
//  Created by 이창준 on 7/24/24.
//

import SwiftUI

extension View {
    public func onScrollOffsetChange(
        for coordinateSpace: NamedCoordinateSpace,
        _ handler: @escaping (CGPoint?) -> Void
    )
        -> some View
    {
        modifier(ScrollOffsetTracker(coordinateSpace: coordinateSpace, handler: handler))
    }
}

// MARK: - ScrollOffsetTracker

private struct ScrollOffsetTracker: ViewModifier {
    let coordinateSpace: NamedCoordinateSpace
    let handler: (CGPoint?) -> Void

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: proxy.bounds(of: coordinateSpace)?.origin
                    )
                }
            )
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: handler)
    }
}

// MARK: - ScrollOffsetPreferenceKey

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint?
    static func reduce(value: inout CGPoint?, nextValue: () -> CGPoint?) {
        // nextValue는 여러 곳의 변화들이 들어오면 그 값들을 모아서 하나에 적용하기 위한 값
        // 변화하는 View가 1개라면 defaultValue만 들어온다.
        if let next = nextValue() {
            value = next
        }
    }
}
