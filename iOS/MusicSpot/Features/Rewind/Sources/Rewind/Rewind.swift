//
//  Rewind.swift
//  Rewind
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

import MSExtension
import MSSwiftUI

@MainActor
extension Rewind: View {

    // MARK: Public

    public var body: some View {
        let photoURLs = selectedJourney.spots.flatMap(\.photoURLs)

        VStack {
            Spacer()
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
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .bottom) {
                    ForEach(Array(zip(photoURLs.indices, photoURLs)), id: \.0) { _, photoURL in
                        cardView(photoURL: photoURL)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, (width - Metric.carouselItemWidth) / 2)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding($currentIndex))
            // TODO: 스크롤 중 타이머 비활성화
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
            let scaleFactor = Metric.carouselItemMaxScaleFactor - consume normalizedDistance * consume itemScaleFactorDistance

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
