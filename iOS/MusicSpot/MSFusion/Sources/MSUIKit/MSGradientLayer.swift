//
//  MSGradientLayer.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.01.11.
//

import UIKit

public class MSGradientLayer: CAGradientLayer {

    // MARK: Computed Properties

    // MARK: Public

    public var gradientColors: [UIColor] = [] {
        didSet { updateColors() }
    }

    // MARK: Overridden Functions

    // swiftlint:disable identifier_name
    public override func hitTest(_: CGPoint) -> CALayer? {
        nil
    }

    // MARK: Functions

    // MARK: Private

    // swiftlint:enable identifier_name

    private func updateColors() {
        colors = gradientColors.map { $0.cgColor }
    }
}
