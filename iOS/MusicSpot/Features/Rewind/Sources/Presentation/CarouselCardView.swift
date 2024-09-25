//
//  CarouselCardView.swift
//  Presentation
//
//  Created by 이창준 on 7/27/24.
//

import SwiftUI

// MARK: - CarouselCardView

struct CarouselCardView: View {

    // MARK: Nested Types

    // MARK: Private

    // MARK: - Constants

    private enum Metric {
        static let carouselItemMinScaleFactor: CGFloat = 1.0
        static let carouselItemMaxScaleFactor: CGFloat = 2.0
        static let carouselItemCornerRadius: CGFloat = 8.0
    }

    // MARK: Properties

    private let photoURL: URL

    // MARK: Lifecycle

    // MARK: - Initializer

    init(photoURL: URL) {
        self.photoURL = photoURL
    }

    // MARK: Content

    // MARK: Internal

    // MARK: - Body

    var body: some View {
        AsyncImage(url: photoURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)

            case .empty, .failure:
                Rectangle().fill(.thinMaterial)

            @unknown default:
                fatalError()
            }
        }
    }

}

// MARK: - Extension

extension CarouselCardView {
    func itemFrame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        spacing: CGFloat? = nil,
        minScale: CGFloat = Metric.carouselItemMinScaleFactor,
        maxScale: CGFloat = Metric.carouselItemMaxScaleFactor
    ) -> some View {
        modifier(
            CarouselItemFrameModifier(
                width: width ?? .zero,
                height: height ?? .zero,
                spacing: spacing ?? .zero,
                minScale: minScale,
                maxScale: maxScale
            )
        )
    }
}

// MARK: - CarouselItemFrameModifier

private struct CarouselItemFrameModifier: ViewModifier {

    // MARK: Properties

    private let width: CGFloat
    private let height: CGFloat
    private let spacing: CGFloat
    private let minScale: CGFloat
    private let maxScale: CGFloat

    // MARK: Lifecycle

    // MARK: - Initializer

    fileprivate init(
        width: CGFloat,
        height: CGFloat,
        spacing: CGFloat,
        minScale: CGFloat,
        maxScale: CGFloat
    ) {
        self.width = width
        self.height = height
        self.spacing = spacing
        self.minScale = minScale
        self.maxScale = maxScale
    }

    // MARK: Content

    // MARK: Internal

    // MARK: - Body

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            let minX = round(proxy.frame(in: .scrollView).minX)

            let offsetRatio = minX / (width + spacing)
            let normalizedDistance = min(abs(offsetRatio), 1.0)
            let itemScaleFactorDistance = maxScale - minScale
            let normalizedFactoredDistance = normalizedDistance * itemScaleFactorDistance
            let scaleFactor = maxScale - normalizedFactoredDistance

            let increasedWidth = width * (scaleFactor - 1)

            content
                .frame(width: width * scaleFactor, height: height)
                .clipShape(.rect(cornerRadius: 8))
                // 중앙 아이템의 넓이가 늘어난만큼(increasedWidth) 바로 다음 아이템의 offsetX가 증가
                // 그 다음 아이템들은 늘어나는 넓이의 최댓값만큼 고정 offsetX 증가
                .offset(x: minX > 0 ? (width - increasedWidth) : .zero)
        }
        .frame(width: width, height: height)
    }

    // MARK: Private

}
