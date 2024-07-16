//
//  ContentView.swift
//  RewindDemo
//
//  Created by 이창준 on 7/17/24.
//

import SwiftUI

import Entity
import Rewind

struct ContentView: View {
    @State var selectedJourney = Journey(
        id: UUID().uuidString,
        title: "Sample",
        date: .init(start: .now),
        coordinates: [],
        spots: [
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: []),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: []),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: []),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: []),
            .init(id: UUID().uuidString, coordinate: .init(), timestamp: .now, photoURLs: []),
        ],
        playlist: [],
        isTraveling: true)

    var body: some View {
        Rewind(selectedJourney: $selectedJourney)
    }
}

#Preview {
    ContentView(selectedJourney: .sample)
}
