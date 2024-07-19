//
//  Rewind.swift
//  Rewind
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

import MSExtension

@MainActor
extension Rewind: View {

    // MARK: Public

    public var body: some View {
        let photoURLs = selectedJourney.spots.flatMap(\.photoURLs)

        GeometryReader { _ in
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
            .aspectRatio(contentMode: .fill)
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
    private func progressView() -> some View {
        let photoURLs = selectedJourney.photoURLs

        HStack(spacing: Metric.progressSpacing) {
            ForEach(Array(zip(photoURLs.indices, photoURLs)), id: \.0) { index, _ in
                GeometryReader { proxy in
                    let width = proxy.size.width

                    // 현재 index 뒤의 progress는 음수가 되어 증가 X
                    let progress = timerProgress - CGFloat(consume index)
                    // progress보다 왼쪽인 부분 자르기
                    let headTrimmedProgress = max(consume progress, 0.0)
                    // progress보다 오른쪽인 부분 자르기
                    let tailTrimmedProgress = min(consume headTrimmedProgress, 1.0)

                    Capsule()
                        .fill(.gray.opacity(0.5))
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(.white)
                                .frame(width: width * tailTrimmedProgress)
                        }
                }
            }
        }
        .padding(.horizontal)
        .frame(height: Metric.progressHeight)
    }

    @ViewBuilder
    private func imageCarouselView() -> some View {
        let photoURLs = selectedJourney.photoURLs

        GeometryReader { proxy in
            let size = proxy.size

            ScrollView(.horizontal) {
                LazyHStack(spacing: Metric.carouselSpacing) {
                    ForEach(Array(zip(photoURLs.indices, photoURLs)), id: \.0) { _, photoURL in
                        AsyncImage(url: photoURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(
                                        width: Metric.carouselItemWidth,
                                        height: Metric.carouselItemHeight)
                                    .clipShape(.rect(cornerRadius: Metric.carouselItemCornerRadius))

                            case .empty, .failure:
                                RoundedRectangle(cornerRadius: Metric.carouselItemCornerRadius)
                                    .fill(.thinMaterial)
                                    .frame(
                                        width: Metric.carouselItemWidth,
                                        height: Metric.carouselItemHeight)

                            @unknown default:
                                ProgressView()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, (size.width - Metric.carouselItemWidth) / 2)
            .scrollIndicators(.never)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding($currentIndex))
        }
        .frame(height: Metric.carouselHeight)
    }
}
