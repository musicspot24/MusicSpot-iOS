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

// MARK: - ImageData

struct ImageData: Identifiable {
    let id = UUID()
    let image: URL
}

// MARK: - RewindView

public struct RewindView: View {

    // MARK: Properties

    let station: StationOf<RewindDripper>

    @State var selectedItem: UUID?

    // MARK: Lifecycle

    public init(station: StationOf<RewindDripper>) {
        self.station = station
    }

    // MARK: Content

    public var body: some View {
        let imageDatas = station.selectedJourney.photoURLs.map { ImageData(image: $0) }

        ZStack {
            AsyncImage(url: imageDatas[0].image) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .ignoresSafeArea()

            VStack {
                Spacer()
                Carousel(
                    data: station.selectedJourney.photoURLs.map { ImageData(image: $0) },
                    configuration: Carousel.Configuration(
                        hasOpacity: true,
                        hasScale: true,
                        cardWidth: 60.0,
                        minimumCardWidth: 40.0,
                        spacing: 8.0
                    ),
                    selection: $selectedItem
                ) { item in
                    GeometryReader { _ in
                        AsyncImage(url: item.image) { image in
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
    }
}

#Preview {
    let station = Station(
        initialState: RewindDripper.State(
            selectedJourney: .sample
        )
    ) {
        RewindDripper()
    }

    RewindView(station: station)
}
