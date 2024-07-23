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
        _ handler: @escaping (CGPoint?) -> Void)
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
                        value: proxy.bounds(of: coordinateSpace)?.origin)
                })
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: handler)
    }
}

// MARK: - ScrollOffsetPreferenceKey

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint? = .zero
    static func reduce(value _: inout CGPoint?, nextValue _: () -> CGPoint?) {
//        value
    }
}
