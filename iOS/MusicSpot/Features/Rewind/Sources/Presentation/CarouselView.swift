//
//  CarouselView.swift
//  Presentation
//
//  Created by 이창준 on 7/27/24.
//

import SwiftUI

import RewindService

struct CarouselView: View {

    // MARK: Nested Types

    private enum Metric {
        static let carouselItemWidth: CGFloat = 40.0
        static let carouselItemHeight: CGFloat = 60.0
        static let carouselSpacing: CGFloat = 4.0
    }

    // MARK: Properties

    // MARK: Internal

    @Environment(RewindService.self) var service

    @Binding private var selectedIndex: Int
    @State private var contentOffsetX: CGFloat?

    // MARK: Lifecycle

    init(selectedIndex: Binding<Int>) {
        _selectedIndex = selectedIndex
    }

    // MARK: Content

    // MARK: - Body

    var body: some View {
        let photoURLs = service.selectedJourney.photoURLs

        GeometryReader { proxy in
            let width = proxy.size.width

            ScrollView(.horizontal) {
                LazyHStack(alignment: .bottom) {
                    ForEach(Array(zip(photoURLs.indices, photoURLs)), id: \.0) { _, photoURL in
                        CarouselCardView(photoURL: photoURL)
                            .itemFrame(
                                width: Metric.carouselItemWidth,
                                height: Metric.carouselItemHeight,
                                spacing: Metric.carouselSpacing
                            )
                    }
                }
                .scrollTargetLayout()
                .onScrollOffsetChange(for: .scrollView(axis: .horizontal)) { offset in
                    contentOffsetX = offset?.x
                }
            }
            .coordinateSpace(.scrollView(axis: .horizontal))
            .simultaneousGesture(
                DragGesture()
                    .onChanged { _ in
                        service.timer.upstream
                            .connect()
                            .cancel()
                    }
                    .onEnded { _ in
                        updateTimer(numberOfPhotoURLs: photoURLs.count)
                    }
            )
            .contentMargins(.horizontal, (width - Metric.carouselItemWidth) / 2)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: Binding($selectedIndex))
            .scrollIndicators(.never)
        }
        .frame(height: Metric.carouselItemHeight)
        .onReceive(service.timer) { _ in
            if service.timerProgress < CGFloat(photoURLs.count) {
                service.progressTimer()
                let index = min(Int(service.timerProgress), photoURLs.count - 1)
                selectedIndex = index
            } else { // 종료
                dismiss()
            }
        }
    }

    // MARK: Private

    // MARK: Functions

    private func updateTimer(numberOfPhotoURLs count: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            let itemSpaceX = Metric.carouselItemWidth + Metric.carouselSpacing
            let index = (contentOffsetX ?? .zero) / itemSpaceX
            let rangedIndex = min(max(0, Int(index)), count)

            service.timerProgress = CGFloat(rangedIndex)
            service.timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect()
        }
    }

    private func dismiss() { }

}
