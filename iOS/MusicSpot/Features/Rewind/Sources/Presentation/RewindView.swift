//
//  RewindView.swift
//  Presentation
//
//  Created by 이창준 on 7/15/24.
//

import SwiftUI

import MSExtension
import MSSwiftUI
import RewindService

public struct RewindView: View {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init() { }

    // MARK: Content

    // MARK: Public

    // MARK: - Body

    public var body: some View {
        let photoURLs = service.selectedJourney.spots.flatMap(\.photoURLs)

        // TODO: Cache 가능한 형태로 변경
        AsyncImage(url: photoURLs[safe: selectedIndex]) { phase in
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
            CarouselView(selectedIndex: $selectedIndex)
                .environment(service)
        }
    }

    // MARK: Internal

    // MARK: Properties

    @Environment(RewindService.self) var service

    @State var selectedIndex: Int = .zero

}
