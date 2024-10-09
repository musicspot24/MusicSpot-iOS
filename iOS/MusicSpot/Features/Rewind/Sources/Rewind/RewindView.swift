//
//  RewindView2.swift
//  Rewind
//
//  Created by 이창준 on 10/2/24.
//

import SwiftUI

import Dripper
import Entity
import MSSwiftUI

// MARK: - RewindView

public struct RewindView: View {

    // MARK: Properties

    var station: StationOf<RewindDripper>

    // MARK: Lifecycle

    public init(station: StationOf<RewindDripper>) {
        self.station = station
    }

    // MARK: Content

    public var body: some View {
        ZStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(station.items) { item in
                        AsyncImage(url: item.imageURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Color.black
                                .ignoresSafeArea()
                                .overlay {
                                    ProgressView()
                                }
                        }
                        .containerRelativeFrame(.horizontal)
                        .clipShape(.rect(cornerRadius: 12.0))
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: station.bind(\.currentItem))
            .scrollIndicators(.never)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))

            VStack {
                Spacer()
                Carousel(
                    data: station.items,
                    configuration: Carousel.Configuration(
                        hasOpacity: true,
                        hasScale: true,
                        cardWidth: 60.0,
                        minimumCardWidth: 40.0,
                        spacing: 8.0
                    ),
                    selection: station.bind(\.currentCardItem)
                ) { item in
                    GeometryReader { _ in
                        AsyncImage(url: item.imageURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 10.0)
                                .background(.regularMaterial)
                                .overlay {
                                    ProgressView()
                                }
                        }
                    }
                    .clipped()
                }
                .frame(height: 80.0)
            }
        }
        .background(.black)
        .onAppear {
            // TODO: 타이머 시작
            station.pour(.timerStarted)
        }
        .onChange(of: station.currentItem) { _, newValue in
            guard let newValue else { return }
            withAnimation(.interpolatingSpring) {
                station.pour(.itemUpdated(newValue))
            }
        }
        .onChange(of: station.currentCardItem) { _, newValue in
            guard let newValue else { return }
            withAnimation(.interpolatingSpring) {
                station.pour(.cardItemUpdated(newValue))
            }
        }
    }
}

#Preview {
    let station = Station(initialState: RewindDripper.State(journey: .sample)) {
        RewindDripper()
    }

    RewindView(station: station)
}
