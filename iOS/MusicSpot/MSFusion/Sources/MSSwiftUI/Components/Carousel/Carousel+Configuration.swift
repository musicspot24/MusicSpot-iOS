//
//  Carousel+Configuration.swift
//  MSFusion
//
//  Created by 이창준 on 10/2/24.
//

import Foundation

extension Carousel {
    public struct Configuration {

        // MARK: Properties

        public var hasOpacity: Bool
        public var opacityValue: CGFloat
        public var hasScale: Bool
        public var scaleValue: CGFloat

        public var cardWidth: CGFloat
        public var minimumCardWidth: CGFloat
        public var spacing: CGFloat
        public var cornerRadius: CGFloat

        // MARK: Lifecycle

        public init(
            hasOpacity: Bool = false,
            opacityValue: CGFloat = 0.4,
            hasScale: Bool = false,
            scaleValue: CGFloat = 0.1,
            cardWidth: CGFloat = 100.0,
            minimumCardWidth: CGFloat = 40.0,
            spacing: CGFloat = 4.0,
            cornerRadius: CGFloat = 10.0
        ) {
            self.hasOpacity = hasOpacity
            self.opacityValue = opacityValue
            self.hasScale = hasScale
            self.scaleValue = scaleValue
            self.cardWidth = cardWidth
            self.minimumCardWidth = minimumCardWidth
            self.spacing = spacing
            self.cornerRadius = cornerRadius
        }
    }
}
