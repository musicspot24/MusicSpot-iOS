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

        // TODO: Cache 가능한 형태로 변경
        AsyncImage(url: photoURLs[safe: currentIndex]) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
                .controlSize(.regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .overlay(progressBar(), alignment: .top)
        .onReceive(timer) { _ in
            if timerProgress < CGFloat(photoURLs.count) {
                // timer duration 0.1
                timerProgress += (0.1 / Metric.progressDuration)
                let index = min(Int(timerProgress), photoURLs.count - 1)
                currentIndex = consume index
            } else { // 종료
            }
        }
    }

    // MARK: Private

    // MARK: - View

    @ViewBuilder
    private func progressBar() -> some View {
        HStack(spacing: Metric.progressSpacing) {
            let photos = selectedJourney.spots.flatMap(\.photoURLs)

            ForEach(Array(zip(photos.indices, photos)), id: \.0) { index, _ in
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
                        .overlay(
                            Capsule()
                                .fill(.white)
                                .frame(width: width * tailTrimmedProgress),
                            alignment: .leading)
                }
            }
        }
        .frame(height: Metric.progressHeight)
        .padding(.horizontal)
    }

    // MARK: - Functions

    private func updateStory() { }
}
