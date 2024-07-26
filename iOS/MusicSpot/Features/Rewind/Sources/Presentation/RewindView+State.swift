//
//  RewindView+State.swift
//  Presentation
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

import Entity
import RewindService

public struct RewindView {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init() { }

    // MARK: Internal

    // MARK: - Global

    // MARK: - Shared

    @Environment(RewindService.self) var service

    // MARK: - Local

    @State var currentIndex: Int = .zero
    @State var contentOffsetX: CGFloat?

}
