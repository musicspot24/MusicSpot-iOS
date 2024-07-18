//
//  Rewind.swift
//  Rewind
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

@MainActor
extension Rewind: View {

    // MARK: Public

    public var body: some View {
        Text(selectedJourney.spots.first!.id)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.white)
            .background(.black)
            .overlay(progressBar(), alignment: .top)
            .onReceive(timer) { _ in
                if timerProgress < CGFloat(selectedJourney.spots.count) {
                    // timer duration 0.1
                    timerProgress += (0.1 / Metric.progressDuration)
                }
            }
    }

    // MARK: Private

    @ViewBuilder
    private func progressBar() -> some View {
        HStack(spacing: Metric.progressSpacing) {
            let spots = selectedJourney.spots
            ForEach(Array(zip(spots.indices, spots)), id: \.0) { index, _ in
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
}
