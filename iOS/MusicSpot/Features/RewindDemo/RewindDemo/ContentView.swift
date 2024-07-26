//
//  ContentView.swift
//  RewindDemo
//
//  Created by 이창준 on 7/17/24.
//

import SwiftUI

import Entity
import RewindPresentation

struct ContentView: View {
    @State var selectedJourney = Journey(
        id: UUID().uuidString,
        title: "Sample",
        date: .init(start: .now),
        coordinates: [],
        spots: [
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum2/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum3/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum4/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum5/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum6/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum7/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum8/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum9/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum10/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum11/600/800")!,
            ]),
        ],
        playlist: [],
        isTraveling: true)

    var body: some View {
        RewindView(selectedJourney: $selectedJourney)
    }
}

#Preview {
    let selectedJourney = Journey(
        id: UUID().uuidString,
        title: "Sample",
        date: .init(start: .now),
        coordinates: [],
        spots: [
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum2/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum3/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum4/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum5/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum6/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum7/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum8/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum9/600/800")!,
                URL(string: "https://picsum.photos/seed/picsum10/600/800")!,
            ]),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: [
                URL(string: "https://picsum.photos/seed/picsum11/600/800")!,
            ]),
        ],
        playlist: [],
        isTraveling: true)

    ContentView(selectedJourney: selectedJourney)
}
