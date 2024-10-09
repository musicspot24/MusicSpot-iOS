//
//  Carousel.swift
//  MSFusion
//
//  Created by 이창준 on 10/2/24.
//

import SwiftUI

// MARK: - Carousel

public struct Carousel<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {

    // MARK: Properties

    public var data: Data
    public var configuration: Configuration

    @Binding public var selection: Data.Element.ID?

    @ViewBuilder public var content: (Data.Element) -> Content

    // MARK: Lifecycle

    public init(
        data: Data,
        configuration: Configuration,
        selection: Binding<Data.Element.ID?>,
        @ViewBuilder content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.configuration = configuration
        _selection = selection
        self.content = content
    }

    // MARK: Content

    public var body: some View {
        GeometryReader {
            let size = $0.size

            ScrollView(.horizontal) {
                HStack(spacing: configuration.spacing) {
                    ForEach(data) { item in
                        ItemView(item)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(
                .horizontal, max((size.width - configuration.cardWidth) / 2, 0)
            )
            .scrollPosition(id: $selection)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .scrollIndicators(.never)
        }
    }

    @ViewBuilder
    func ItemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            let size = proxy.size

            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            let progress = minX / (configuration.cardWidth + configuration.spacing)
            let minimumCardWidth = configuration.minimumCardWidth

            let diffWidth = configuration.cardWidth - minimumCardWidth
            let reducingWidth = progress * diffWidth
            let cappedWidth = min(reducingWidth, diffWidth)

            let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth : min(-cappedWidth, diffWidth))
            let negativeProgress = max(-progress, .zero)

            let opacityValue = configuration.opacityValue * abs(progress) / 2
            let scaleValue = configuration.scaleValue * abs(progress)

            content(item)
                .frame(width: size.width, height: size.height)
                .frame(width: resizedFrameWidth)
                .opacity(configuration.hasOpacity ? 1 - opacityValue : 1)
                .scaleEffect(configuration.hasScale ? 1 - scaleValue : 1)
                .mask {
                    let hasScale = configuration.hasScale
                    let scaledHeight = (1 - scaleValue) * size.height
                    RoundedRectangle(cornerRadius: configuration.cornerRadius)
                        .frame(height: hasScale ? max(scaledHeight, 0) : size.height)
                }
                .offset(x: -reducingWidth)
                .offset(x: min(progress, 1) * diffWidth)
                .offset(x: negativeProgress * diffWidth)
        }
        .frame(width: configuration.cardWidth)
    }
}

// MARK: - ImageData

private struct ImageData: Identifiable {
    let id = UUID()
    let url: URL?
}

#Preview {
    @Previewable @State var activeID: UUID?

    let images = [
        URL(string: "https://picsum.photos/seed/picsum/600/800"),
        URL(string: "https://picsum.photos/seed/picsum2/600/800"),
        URL(string: "https://picsum.photos/seed/picsum3/600/800"),
        URL(string: "https://picsum.photos/seed/picsum4/600/800"),
        URL(string: "https://picsum.photos/seed/picsum5/600/800"),
        URL(string: "https://picsum.photos/seed/picsum6/600/800"),
        URL(string: "https://picsum.photos/seed/picsum7/600/800"),
        URL(string: "https://picsum.photos/seed/picsum8/600/800"),
        URL(string: "https://picsum.photos/seed/picsum9/600/800"),
        URL(string: "https://picsum.photos/seed/picsum10/600/800"),
    ].map {
        ImageData(url: $0)
    }

    NavigationStack {
        VStack {
            Spacer()

            Carousel(
                data: images,
                configuration: Carousel.Configuration(
                    hasOpacity: true,
                    opacityValue: 0.4,
                    hasScale: true,
                    scaleValue: 0.2
                ),
                selection: $activeID
            ) { item in
                GeometryReader { _ in
                    AsyncImage(url: item.url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                }
                .clipped()
            }
            .frame(height: 100.0)
        }
    }
}
