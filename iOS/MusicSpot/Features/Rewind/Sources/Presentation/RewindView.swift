//
//  RewindView.swift
//  Presentation
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

import MSExtension
import MSSwiftUI

@MainActor
extension RewindView: View {

    // MARK: - Constants

    private enum Metric {
        static let carouselSpacing: CGFloat = 4.0
        static let carouselHeight: CGFloat = 60.0
        static let carouselItemWidth: CGFloat = 40.0
        static let carouselItemMinScaleFactor: CGFloat = 1.0
        static let carouselItemMaxScaleFactor: CGFloat = 2.0
        static let carouselItemCornerRadius: CGFloat = 8.0

        /// 사진 하나의 출력 시간(s)
        static let progressDuration: CGFloat = 5.0
    }

    // MARK: Public

    public var body: some View {
        let photoURLs = selectedJourney.spots.flatMap(\.photoURLs)

        // TODO: Cache 가능한 형태로 변경
        AsyncImage(url: photoURLs[safe: currentIndex]) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image.resizable()
            case .failure:
                ProgressView()
            @unknown default:
                ProgressView()
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .ignoresSafeArea()
        .background(.black)
        .overlay(alignment: .bottom) {
            imageCarouselView()
        }
        .onReceive(timer) { _ in
            if timerProgress < CGFloat(photoURLs.count) {
                // timer duration 0.1
                timerProgress += (0.1 / Metric.progressDuration)
                let index = min(Int(timerProgress), photoURLs.count - 1)
                currentIndex = consume index
            } else { // 종료
                // TODO: 모든 미디어 출력 후 행동 구현
            }
        }
    }

    // MARK: Private

    // MARK: - View

    @ViewBuilder
    private func imageCarouselView() -> some View {
        let photoURLs = selectedJourney.photoURLs

        GeometryReader { proxy in
            let width = proxy.size.width

            ScrollView(.horizontal) {
                LazyHStack(alignment: .bottom) {
                    ForEach(Array(zip(photoURLs.indices, photoURLs)), id: \.0) { _, photoURL in
                        cardView(photoURL: photoURL)
                    }
                }
                .scrollTargetLayout()
                .onScrollOffsetChange(for: .scrollView(axis: .horizontal)) { offset in
                    self.contentOffsetX = offset?.x
                }
            }
            .coordinateSpace(.scrollView(axis: .horizontal))
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        timer.upstream.connect().cancel()
                    }
                    .onEnded { _ in
                        DispatchQueue.main.async {
                            let index = (contentOffsetX ?? .zero) / Metric.carouselItemWidth
                            let rangedIndex = min(max(0, Int(index)), photoURLs.count)
                            timerProgress = CGFloat(rangedIndex)
                            timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
                        }
                    })
            .contentMargins(.horizontal, (consume width - Metric.carouselItemWidth) / 2)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding($currentIndex))
            .scrollIndicators(.never)
        }
        .frame(height: Metric.carouselHeight)
    }

    @ViewBuilder
    private func cardView(photoURL: URL?) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minX = round(proxy.frame(in: .scrollView).minX)

            let offsetRatio = consume minX / (Metric.carouselItemWidth + Metric.carouselSpacing)
            let normalizedDistance = min(abs(consume offsetRatio), 1.0)
            let itemScaleFactorDistance = Metric.carouselItemMaxScaleFactor - Metric.carouselItemMinScaleFactor
            let normalizedFactoredDistance = consume normalizedDistance * consume itemScaleFactorDistance
            let scaleFactor = Metric.carouselItemMaxScaleFactor - consume normalizedFactoredDistance

            let increasedWidth = Metric.carouselItemWidth * (scaleFactor - 1)

            AsyncImage(url: photoURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()

                case .empty, .failure:
                    Rectangle().fill(.thinMaterial)

                @unknown default:
                    fatalError()
                }
            }
            .frame(width: Metric.carouselItemWidth * consume scaleFactor, height: size.height)
            .clipShape(.rect(cornerRadius: 8.0))
            // 중앙 아이템의 넓이가 늘어난만큼(increasedWidth) 바로 다음 아이템의 offsetX가 증가
            // 그 다음 아이템들은 늘어나는 넓이의 최댓값만큼 고정 offsetX 증가
            .offset(
                x: offsetRatio > 0
                    ? (Metric.carouselItemWidth - consume increasedWidth)
                    : .zero)
        }
        .frame(width: Metric.carouselItemWidth, height: Metric.carouselHeight)
    }
}
